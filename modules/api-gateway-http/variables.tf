
variable "tags" {
  description = "Tags to apply to the API Gateway resources."
  type        = map(string)
  default     = {}
}

variable "lambda_function_invoke_arn" {
  description = "lambda to invoke the HTTP lambda function"
  type        = string

}

variable "name" {
  description = "Name of the API Gateway HTTP API."
  type        = string
}