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

variable "stage_name" {
  description = "WebSocket API stage name, used as an environment variable for the Lambda function."
  type        = string
}

variable "domain_name" {
  description = "WebSocket API domain name, used for constructing the WebSocket URL in the Lambda environment variables."
  type        = string
}