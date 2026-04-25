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
  lambda_source_path_base = var.lambda_source_path_base != null ? trimsuffix(var.lambda_source_path_base, "/") : null

  connect_lambda_source_path = abspath(
    local.lambda_source_path_base != null
    ? "${local.lambda_source_path_base}/${var.connect_lambda_source_path}"
    : var.connect_lambda_source_path
  )

  disconnect_lambda_source_path = abspath(
    local.lambda_source_path_base != null
    ? "${local.lambda_source_path_base}/${var.disconnect_lambda_source_path}"
    : var.disconnect_lambda_source_path
  )

  default_lambda_source_path = abspath(
    local.lambda_source_path_base != null
    ? "${local.lambda_source_path_base}/${var.default_lambda_source_path}"
    : var.default_lambda_source_path
  )

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

  shared_lambda_environment_variables = {
    WS_STAGE            = var.stage_name,
    WS_DOMAIN_NAME      = module.websocket.domain_name,
    DYNAMODB_TABLE_NAME = module.dynamodb.dynamodb_table_name
    ENVIRONMENT          = var.stage_name
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

  function_name               = "${var.application_name}-producer-lambda"
  source_path                 = var.producer_lambda_source_path
  handler                     = var.producer_lambda_handler
  runtime                     = var.lambda_runtime
  http_api_execution_arn      = module.http_gateway.api_execution_arn
  websocket_api_execution_arn = module.websocket.api_execution_arn
  enable_vpc                  = false
  environment_variables       = local.shared_lambda_environment_variables
  dynamodb_crud_permissions   = local.dynamodb_crud_permissions

  tags = var.tags
}

module "websocket_connect_lambda" {
  source = "./modules/websocket-lambda-function"

  function_name               = "${var.application_name}-connect-lambda"
  source_path                 = local.connect_lambda_source_path
  handler                     = var.connect_lambda_handler
  runtime                     = var.lambda_runtime
  websocket_api_execution_arn = module.websocket.api_execution_arn
  dynamodb_crud_permissions   = local.dynamodb_crud_permissions
  environment_variables       = local.shared_lambda_environment_variables

  tags = var.tags
}

module "websocket_disconnect_lambda" {
  source = "./modules/websocket-lambda-function"

  function_name               = "${var.application_name}-disconnect-lambda"
  source_path                 = local.disconnect_lambda_source_path
  handler                     = var.disconnect_lambda_handler
  runtime                     = var.lambda_runtime
  websocket_api_execution_arn = module.websocket.api_execution_arn
  dynamodb_crud_permissions   = local.dynamodb_crud_permissions
  environment_variables       = local.shared_lambda_environment_variables

  tags = var.tags
}

module "websocket_default_lambda" {
  source                      = "./modules/websocket-lambda-function"
  function_name               = "${var.application_name}-default-lambda"
  source_path                 = local.default_lambda_source_path
  handler                     = var.default_lambda_handler
  runtime                     = var.lambda_runtime
  websocket_api_execution_arn = module.websocket.api_execution_arn
  dynamodb_crud_permissions   = local.dynamodb_crud_permissions
  environment_variables       = local.shared_lambda_environment_variables

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