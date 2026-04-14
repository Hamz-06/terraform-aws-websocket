output "connect_lambda_invoke_arn" {
  description = "Invoke ARN for the generated $connect Lambda function."
  value       = module.websocket_connect_lambda.lambda_invoke_arn
}

output "disconnect_lambda_invoke_arn" {
  description = "Invoke ARN for the generated $disconnect Lambda function."
  value       = module.websocket_disconnect_lambda.lambda_invoke_arn
}

output "websocket_api_endpoint" {
  description = "WebSocket API endpoint URL."
  value       = module.websocket.wss_api_endpoint
}

output "websocket_domain_name" {
  description = "Domain name of the WebSocket API."
  value       = module.websocket.domain_name
}

output "producer_http_api_endpoint" {
  description = "HTTP API endpoint URL for the producer Lambda function."
  value       = module.http_gateway.api_endpoint
}

