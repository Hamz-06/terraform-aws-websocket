

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table. If not provided, it will be generated based on the application name."
  value       = module.dynamodb_table.dynamodb_table_id
}