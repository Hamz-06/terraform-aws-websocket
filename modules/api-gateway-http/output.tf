
output "api_execution_arn" {
  description = "ARN for API Gateway execution"
  value       = module.http_api.apigatewayv2_api_execution_arn
}

output "api_endpoint" {
  description = "HTTP API endpoint URL."
  value       = module.http_api.apigatewayv2_api_api_endpoint
}