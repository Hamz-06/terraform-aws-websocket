variable "region" {
  description = "The AWS region where resources will be created (e.g., us-east-1)."
  type        = string
}

variable "application_name" {
  description = "Application name used as a prefix for resource naming."
  type        = string
}

variable "stage_name" {
  description = "Stage name for the WebSocket API (for example, local, dev, or prod)."
  type        = string
  default     = "local"
}

variable "lambda_runtime" {
  description = "Lambda runtime used in s3_zip mode."
  type        = string
  default     = "nodejs24.x"
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Number of days to retain Lambda CloudWatch log groups."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags to apply to all supported resources."
  type        = map(string)
  default     = {}
}

variable "additional_policy_statements" {
  description = "Extra IAM policy statements to attach to every Lambda function. Each key is a unique statement label. Statements support effect with either actions or not_actions, and either resources or not_resources."
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

variable "lambda_environment_variables" {
  description = "Additional environment variables to inject into every Lambda function, merged with the shared defaults."
  type        = map(string)
  default     = {}
}
