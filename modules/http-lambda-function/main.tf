
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
    http_api = {
      service    = "apigateway"
      source_arn = "${var.http_api_execution_arn}/*/*"
    }
  }

  environment_variables = var.environment_variables

  # Optional VPC configuration
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
