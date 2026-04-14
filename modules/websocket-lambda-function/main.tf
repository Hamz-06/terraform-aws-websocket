
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

  tags = var.tags
}
