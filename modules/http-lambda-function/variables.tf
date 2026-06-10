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

variable "additional_policy_statements" {
  description = "Optional map of extra IAM policy statements to attach to the Lambda function. Statements support effect with either actions or not_actions, and either resources or not_resources."
  type = map(object({
    effect        = string
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    resources     = optional(list(string))
    not_resources = optional(list(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for statement in values(var.additional_policy_statements) : (
        ((try(length(statement.actions), 0) > 0) != (try(length(statement.not_actions), 0) > 0)) &&
        ((try(length(statement.resources), 0) > 0) != (try(length(statement.not_resources), 0) > 0))
      )
    ])
    error_message = "Each additional policy statement must include exactly one of actions/not_actions and exactly one of resources/not_resources."
  }

  validation {
    condition = (
      !contains(keys(var.additional_policy_statements), "manage_connections") &&
      !contains(keys(var.additional_policy_statements), "dynamodb")
    )
    error_message = "additional_policy_statements keys 'manage_connections' and 'dynamodb' are reserved by the module."
  }
}