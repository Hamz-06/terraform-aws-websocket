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

variable "http_api_execution_arn" {
  description = "Optional API execution ARN for HTTP API allowed triggers. If provided, the Lambda can be invoked by the HTTP API."
  type        = string
  default     = null
}

variable "websocket_api_execution_arn" {
  description = "WebSocket API execution ARN used to authorize @connections management calls."
  type        = string
}

variable "enable_vpc" {
  description = "Whether to attach the Lambda to a VPC."
  type        = bool
  default     = false
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for VPC attachment."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs to assign to the Lambda function when VPC is enabled."
  type        = list(string)
  default     = []
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