output "lambda_arn" {
  description = "ARN of the Lambda function."
  value       = module.lambda_function.lambda_function_arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function."
  value       = module.lambda_function.lambda_function_invoke_arn
}
