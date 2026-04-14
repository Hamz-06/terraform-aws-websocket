

module "http_api" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 3.0"

  name          = var.name
  protocol_type = "HTTP"

  create_default_stage   = true
  create_api_domain_name = false

  integrations = {
    // potentially change
    "POST /invoke" = {
      integration_type       = "AWS_PROXY"
      integration_uri        = var.lambda_function_invoke_arn
      payload_format_version = "2.0"
    }
  }

  tags = var.tags
}