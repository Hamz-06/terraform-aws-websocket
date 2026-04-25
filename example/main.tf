terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


module "websocket" {
  source = "../"

  region           = "us-east-1"
  application_name = "example-ws"

  lambda_source_path_base       = path.module
  connect_lambda_source_path    = "dist/lambda/connect.js"
  disconnect_lambda_source_path = "dist/lambda/disconnect.js"
  default_lambda_source_path    = "dist/lambda/default.js"
  producer_lambda_source_path   = "dist/lambda/producer.js"

  stage_name = "dev"

  tags = {
    "test" : "dummy-value"
  }
}