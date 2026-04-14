variable "region" {
  description = "The AWS region where resources will be created (e.g., us-east-1)."
  type        = string
}

variable "application_name" {
  description = "Application name used as a prefix for resource naming."
  type        = string
}

variable "stage_name" {
  description = "Stage name for the WebSocket API (for example, $default, dev, or prod)."
  type        = string
  default     = "$default"
}

// ** connect integration variables **
variable "connect_lambda_source_path" {
  description = "Path to the source file or directory for the $connect Lambda function."
  type        = string
}

variable "connect_lambda_handler" {
  description = "Handler entrypoint for the $connect Lambda function (for example, connect.handler)."
  type        = string
  default     = "connect.handler"
}


// ** disconnect integration variables **
variable "disconnect_lambda_source_path" {
  description = "Path to the source file or directory for the $disconnect Lambda function."
  type        = string
}

variable "disconnect_lambda_handler" {
  description = "Handler entrypoint for the $disconnect Lambda function (for example, disconnect.handler)."
  type        = string
  default     = "disconnect.handler"
}

// ** default integration variables **
variable "default_lambda_source_path" {
  description = "Path to the source file or directory for the $default Lambda function."
  type        = string
}
variable "default_lambda_handler" {
  description = "Handler entrypoint for the $default Lambda function (for example, default.handler)."
  type        = string
  default     = "default.handler"

}

// ** producer integration variables **
variable "producer_lambda_source_path" {
  description = "Path to the source file or directory for the producer Lambda function."
  type        = string

}

variable "producer_lambda_handler" {
  description = "HTTP Lambda handler entrypoint for the producer Lambda function"
  type        = string
  default     = "producer.handler"
}

variable "lambda_source_path_base" {
  description = "Optional base path prepended to relative Lambda source paths. Set this to path.module in the calling module when source files are module-relative."
  type        = string
  default     = null
}

variable "lambda_runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "nodejs20.x"
}

variable "tags" {
  description = "Tags to apply to all supported resources."
  type        = map(string)
  default     = {}
}
