# Bootstrap artifact used ONLY for initial Lambda creation.
# Terraform never redeploys code after this — CI owns all updates via
# `aws lambda update-function-code`.
data "archive_file" "bootstrap" {
  type        = "zip"
  output_path = "${path.module}/bootstrap.zip"
  source {
    content  = "exports.handler = async () => ({ statusCode: 200, body: 'bootstrap' })"
    filename = "index.js"
  }
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  package_type  = "Zip"
  runtime       = var.runtime
  handler       = var.handler

  create_package         = false
  local_existing_package = data.archive_file.bootstrap.output_path

  # Never let Terraform overwrite code deployed by CI.
  ignore_source_code_hash = true

  create_current_version_allowed_triggers = false
  cloudwatch_logs_retention_in_days       = var.cloudwatch_logs_retention_in_days

  allowed_triggers = {
    websocket_api = {
      service    = "apigateway"
      source_arn = "${var.websocket_api_execution_arn}/*/*"
    }
  }

  environment_variables = var.environment_variables

  attach_policy_statements = true
  policy_statements = merge(
    {
      manage_connections = {
        effect    = "Allow"
        actions   = ["execute-api:ManageConnections"]
        resources = ["${var.websocket_api_execution_arn}/*"]
      }
    },
    var.dynamodb_crud_permissions == null ? {} : {
      dynamodb = var.dynamodb_crud_permissions
    },
    var.additional_policy_statements
  )

  tags = var.tags
}
