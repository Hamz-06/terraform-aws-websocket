
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  runtime       = var.runtime
  handler       = var.handler

  create_package                          = true
  source_path                             = var.source_path
  create_current_version_allowed_triggers = false

  # API Gateway allowed triggers
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
    }
  )

  tags = var.tags
}
