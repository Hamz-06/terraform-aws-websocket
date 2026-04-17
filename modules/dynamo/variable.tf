
variable "name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DynamoDB resources."
  type        = map(string)
}
