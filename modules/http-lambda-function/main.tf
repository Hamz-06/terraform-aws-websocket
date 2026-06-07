module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  package_type  = "Zip"
  runtime       = var.runtime
  handler       = var.handler

  create_package = false
  s3_existing_package = {
    bucket     = var.s3_artifact.bucket
    key        = var.s3_artifact.key
    version_id = try(var.s3_artifact.object_version, null)
  }

  # Keep hash metadata explicit for deterministic artifact tracking.
  hash_extra                              = var.s3_artifact.source_code_hash
  ignore_source_code_hash                 = false
  create_current_version_allowed_triggers = false
  cloudwatch_logs_retention_in_days       = var.cloudwatch_logs_retention_in_days

  allowed_triggers = {
    http_api = {
      service    = "apigateway"
      source_arn = "${var.http_api_execution_arn}/*/*"
    }
  }

  environment_variables = var.environment_variables

  vpc_subnet_ids         = var.enable_vpc ? var.private_subnet_ids : null
  vpc_security_group_ids = var.enable_vpc ? var.security_group_ids : null

  attach_policy_statements = true
  policy_statements = merge(
    {
      manage_connections = {
        effect  = "Allow"
        actions = ["execute-api:ManageConnections", "execute-api:Invoke"]
        resources = [
          "${var.websocket_api_execution_arn}/*",
        ]
      }
    },
    var.dynamodb_crud_permissions == null ? {} : {
      dynamodb = var.dynamodb_crud_permissions
    }
  )

  tags = var.tags
}
