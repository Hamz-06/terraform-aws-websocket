

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "5.5.0"

  name      = var.name
  hash_key  = "user_id"
  range_key = "connection_id"

  billing_mode = "PAY_PER_REQUEST"

  ttl_enabled        = true
  ttl_attribute_name = "ttl"

  # Disable optional paid durability features for lowest ongoing cost.
  point_in_time_recovery_enabled = false
  deletion_protection_enabled    = false

  attributes = [
    {
      name = "user_id"
      type = "S"
    },
    {
      name = "connection_id"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "connection-id-index"
      hash_key        = "connection_id"
      projection_type = "ALL"
    }
  ]

  tags = var.tags
}