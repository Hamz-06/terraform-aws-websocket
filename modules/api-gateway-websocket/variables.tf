variable "name" {
  description = "Name of the API Gateway WebSocket API."
  type        = string
}

variable "stage_name" {
  description = "Stage name for the WebSocket API. Use $default for default stage."
  type        = string
  default     = "$default"
}

variable "connect_lambda_invoke_arn" {
  description = "Lambda invoke ARN for the $connect route."
  type        = string
}

variable "disconnect_lambda_invoke_arn" {
  description = "Lambda invoke ARN for the $disconnect route."
  type        = string
}

variable "default_lambda_invoke_arn" {
  description = "Optional Lambda invoke ARN for the $default route."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the API Gateway resources."
  type        = map(string)
  default     = {}
}
