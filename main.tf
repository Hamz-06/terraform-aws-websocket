terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.40.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  dynamodb_crud_permissions = {
    effect = "Allow",
    actions = [
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeTable",
      "dynamodb:ConditionCheckItem",
    ],
    resources = [
      "${module.dynamodb.dynamodb_table_arn}",
      "${module.dynamodb.dynamodb_table_arn}/index/*"
    ]
  }

  shared_lambda_environment_variables = merge(
    {
      WS_STAGE            = var.stage_name,
      WS_DOMAIN_NAME      = module.websocket.domain_name,
      DYNAMODB_TABLE_NAME = module.dynamodb.dynamodb_table_name
      ENVIRONMENT         = var.stage_name
    },
    var.lambda_environment_variables
  )

  normalized_lambdas = {
    connect = {
      handler = var.lambda_handlers.connect
      s3      = var.lambdas.connect.s3
    }
    disconnect = {
      handler = var.lambda_handlers.disconnect
      s3      = var.lambdas.disconnect.s3
    }
    default = {
      handler = var.lambda_handlers.default
      s3      = var.lambdas.default.s3
    }
    producer = {
      handler = var.lambda_handlers.producer
      s3      = var.lambdas.producer.s3
    }
  }
}

// ** dynamo **
module "dynamodb" {
  source = "./modules/dynamo"
  name   = "${var.application_name}-dynamodb-table"

  tags = var.tags
}

// ** lambda **
module "producer_lambda" {
  source = "./modules/http-lambda-function"

  function_name                     = "${var.application_name}-producer-lambda"
  s3_artifact                       = local.normalized_lambdas.producer.s3
  handler                           = local.normalized_lambdas.producer.handler
  runtime                           = var.lambda_runtime
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  http_api_execution_arn            = module.http_gateway.api_execution_arn
  websocket_api_execution_arn       = module.websocket.api_execution_arn
  enable_vpc                        = false
  environment_variables             = local.shared_lambda_environment_variables
  dynamodb_crud_permissions         = local.dynamodb_crud_permissions
  additional_policy_statements      = var.additional_policy_statements

  tags = var.tags
}

module "websocket_connect_lambda" {
  source = "./modules/websocket-lambda-function"

  function_name                     = "${var.application_name}-connect-lambda"
  s3_artifact                       = local.normalized_lambdas.connect.s3
  handler                           = local.normalized_lambdas.connect.handler
  runtime                           = var.lambda_runtime
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  websocket_api_execution_arn       = module.websocket.api_execution_arn
  dynamodb_crud_permissions         = local.dynamodb_crud_permissions
  environment_variables             = local.shared_lambda_environment_variables
  additional_policy_statements      = var.additional_policy_statements

  tags = var.tags
}

module "websocket_disconnect_lambda" {
  source = "./modules/websocket-lambda-function"

  function_name                     = "${var.application_name}-disconnect-lambda"
  s3_artifact                       = local.normalized_lambdas.disconnect.s3
  handler                           = local.normalized_lambdas.disconnect.handler
  runtime                           = var.lambda_runtime
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  websocket_api_execution_arn       = module.websocket.api_execution_arn
  dynamodb_crud_permissions         = local.dynamodb_crud_permissions
  environment_variables             = local.shared_lambda_environment_variables
  additional_policy_statements      = var.additional_policy_statements

  tags = var.tags
}

module "websocket_default_lambda" {
  source                            = "./modules/websocket-lambda-function"
  function_name                     = "${var.application_name}-default-lambda"
  s3_artifact                       = local.normalized_lambdas.default.s3
  handler                           = local.normalized_lambdas.default.handler
  runtime                           = var.lambda_runtime
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  websocket_api_execution_arn       = module.websocket.api_execution_arn
  dynamodb_crud_permissions         = local.dynamodb_crud_permissions
  environment_variables             = local.shared_lambda_environment_variables
  additional_policy_statements      = var.additional_policy_statements

  tags = var.tags
}

// ** websocket **
module "websocket" {
  source     = "./modules/api-gateway-websocket"
  name       = "${var.application_name}-websocket-api-gateway"
  stage_name = var.stage_name

  connect_lambda_invoke_arn    = module.websocket_connect_lambda.lambda_invoke_arn
  disconnect_lambda_invoke_arn = module.websocket_disconnect_lambda.lambda_invoke_arn
  default_lambda_invoke_arn    = module.websocket_default_lambda.lambda_invoke_arn

  tags = var.tags
}



// ** http API **
module "http_gateway" {
  name                       = "${var.application_name}-http-api-gateway"
  source                     = "./modules/api-gateway-http"
  lambda_function_invoke_arn = module.producer_lambda.lambda_invoke_arn

  tags = var.tags
}