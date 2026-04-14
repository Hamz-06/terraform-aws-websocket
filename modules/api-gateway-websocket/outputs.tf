output "api_id" {
  description = "ID of the API Gateway WebSocket API."
  value       = module.api_gateway_websocket.api_id
}

output "wss_api_endpoint" {
  description = "Invoke URL of the API Gateway WebSocket API."
  value       = module.api_gateway_websocket.api_endpoint
}

output "stage_arn" {
  description = "ARN of the deployed WebSocket API stage."
  value       = module.api_gateway_websocket.stage_arn
}

output "api_execution_arn" {
  description = "ARN for API Gateway execution, used for Lambda permissions."
  value       = module.api_gateway_websocket.api_execution_arn
}

// domain name is not directly available from the module
output "domain_name" {
  description = "Name of the API Gateway WebSocket API."
  value       = split("/", replace(replace(module.api_gateway_websocket.api_endpoint, "wss://", ""), "https://", ""))[0]
}
