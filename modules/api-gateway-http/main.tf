

module "http_api" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "6.1.0"

  name                  = var.name
  protocol_type         = "HTTP"
  create_domain_name    = false
  create_domain_records = false

  routes = {
    "POST /invoke" = {
      integration = {
        type           = "AWS_PROXY"
        uri            = var.lambda_function_invoke_arn
        payload_format = "2.0"
      }
      authorization_type = "NONE"
    }
  }

  tags = var.tags
}