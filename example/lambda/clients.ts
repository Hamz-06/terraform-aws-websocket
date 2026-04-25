import { ApiGatewayManagementApiClient } from "@aws-sdk/client-apigatewaymanagementapi"
import { DynamoDBClient } from "@aws-sdk/client-dynamodb"
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb"

// dynamo client
export const ddbClient = new DynamoDBClient({
  region: process.env.AWS_REGION,
})

export const docClient = DynamoDBDocumentClient.from(ddbClient)

// api gateway
export const wsClient = new ApiGatewayManagementApiClient({
  region: process.env.AWS_REGION,
  endpoint: `https://${process.env.WS_DOMAIN_NAME}/${process.env.WS_STAGE}`,
})