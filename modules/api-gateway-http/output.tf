
output "api_execution_arn" {
  description = "ARN for API Gateway execution"
  value       = module.http_api.api_execution_arn
}

output "api_endpoint" {
  description = "HTTP API endpoint URL."
  value       = module.http_api.api_endpoint
}

output "api_id" {
  description = "ID of the HTTP API."
  value       = module.http_api.api_id
}

output "stage_name" {
  description = "Stage name of the HTTP API."
  value       = module.http_api.stage_id
}