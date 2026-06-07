variable "function_name" {
  description = "Name for the Lambda function."
  type        = string
}

variable "handler" {
  description = "Lambda handler entrypoint used in s3_zip mode (for example, index.handler)."
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime used in s3_zip mode."
  type        = string
  default     = "nodejs20.x"
}

variable "s3_artifact" {
  description = "S3 artifact metadata used by this module."
  type = object({
    bucket           = string
    key              = string
    source_code_hash = string
    object_version   = optional(string)
  })

  validation {
    condition = (
      length(trimspace(var.s3_artifact.bucket)) > 0 &&
      length(trimspace(var.s3_artifact.key)) > 0 &&
      length(trimspace(var.s3_artifact.source_code_hash)) > 0
    )
    error_message = "s3_artifact.bucket, s3_artifact.key, and s3_artifact.source_code_hash must be non-empty."
  }
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Number of days to retain CloudWatch logs for the Lambda function."
  type        = number
  default     = 14
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