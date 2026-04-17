module "api_gateway_websocket" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "6.1.0"

  name                       = var.name
  description                = "WebSocket API for ${var.name}"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"

  create_stage = true
  stage_name   = var.stage_name

  stage_default_route_settings = {
    data_trace_enabled       = false
    detailed_metrics_enabled = true
    logging_level            = "OFF"
    throttling_burst_limit   = 500
    throttling_rate_limit    = 1000
  }

  stage_access_log_settings = null

  create_domain_name = false

  routes = {
    "$connect" = {
      integration = {
        type   = "AWS_PROXY"
        method = "POST"
        uri    = var.connect_lambda_invoke_arn
      }
    }

    "$disconnect" = {
      integration = {
        type   = "AWS_PROXY"
        method = "POST"
        uri    = var.disconnect_lambda_invoke_arn
      }
    }

    "$default" = {
      integration = {
        type   = "AWS_PROXY"
        method = "POST"
        uri    = var.default_lambda_invoke_arn
      }
    }

  }

  tags = var.tags
}