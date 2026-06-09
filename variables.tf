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

variable "lambda_handlers" {
  description = "Lambda handlers used in s3_zip mode for websocket and producer functions."
  type = object({
    connect    = string
    disconnect = string
    default    = string
    producer   = string
  })
  default = {
    connect    = "connect.handler"
    disconnect = "disconnect.handler"
    default    = "default.handler"
    producer   = "producer.handler"
  }
}

variable "lambdas" {
  description = <<-EOT
  Artifact contract for all 4 Lambda functions (connect, disconnect, default, producer).
  Provide lambdas.<name>.s3.bucket, key, source_code_hash, and optional object_version.

  Use immutable artifact identifiers (for example, commit SHA or content-addressed keys/tags).
  Avoid mutable references such as latest when you need deterministic deployments.
  EOT

  type = object({
    connect = object({
      s3 = object({
        bucket           = string
        key              = string
        source_code_hash = string
        object_version   = optional(string)
      })
    })
    disconnect = object({
      s3 = object({
        bucket           = string
        key              = string
        source_code_hash = string
        object_version   = optional(string)
      })
    })
    default = object({
      s3 = object({
        bucket           = string
        key              = string
        source_code_hash = string
        object_version   = optional(string)
      })
    })
    producer = object({
      s3 = object({
        bucket           = string
        key              = string
        source_code_hash = string
        object_version   = optional(string)
      })
    })
  })

  validation {
    condition = (
      length(trimspace(var.lambdas.connect.s3.bucket)) > 0 &&
      length(trimspace(var.lambdas.connect.s3.key)) > 0 &&
      length(trimspace(var.lambdas.connect.s3.source_code_hash)) > 0 &&
      length(trimspace(var.lambdas.disconnect.s3.bucket)) > 0 &&
      length(trimspace(var.lambdas.disconnect.s3.key)) > 0 &&
      length(trimspace(var.lambdas.disconnect.s3.source_code_hash)) > 0 &&
      length(trimspace(var.lambdas.default.s3.bucket)) > 0 &&
      length(trimspace(var.lambdas.default.s3.key)) > 0 &&
      length(trimspace(var.lambdas.default.s3.source_code_hash)) > 0 &&
      length(trimspace(var.lambdas.producer.s3.bucket)) > 0 &&
      length(trimspace(var.lambdas.producer.s3.key)) > 0 &&
      length(trimspace(var.lambdas.producer.s3.source_code_hash)) > 0
    )
    error_message = "Each lambdas.<function>.s3 must include non-empty bucket, key, and source_code_hash."
  }
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
