variable "function_name" {
  description = "Name for the Lambda function."
  type        = string
}

variable "source_path" {
  description = "Path to the Lambda source file or directory."
  type        = string
}

variable "handler" {
  description = "Lambda handler entrypoint (for example, index.handler)."
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "nodejs20.x"
}

variable "tags" {
  description = "Tags to apply to resources created by this module."
  type        = map(string)
  default     = {}
}

variable "websocket_api_execution_arn" {
  description = "Optional API execution ARN for WebSocket API allowed triggers. If provided, the Lambda can be invoked by the WebSocket API and will have permissions to manage connections."
  type        = string
  default     = null
}

variable "dynamodb_crud_permissions" {
  description = "Optional IAM policy statement for DynamoDB CRUD permissions. If provided, the Lambda will have these permissions in addition to the default @connections management permissions."
  type        = any
  default     = null
}

variable "environment_variables" {
  description = "Optional map of environment variables to set for the Lambda function."
  type        = map(string)
  default     = {}
}