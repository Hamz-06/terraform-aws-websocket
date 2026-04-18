import {
  APIGatewayEventWebsocketRequestContextV2,
  APIGatewayProxyEventV2WithRequestContext,
} from "aws-lambda"
import {
  PutCommand,
} from "@aws-sdk/lib-dynamodb"
import { docClient } from "./clients"


type WebSocketConnectEvent =
  APIGatewayProxyEventV2WithRequestContext<
    APIGatewayEventWebsocketRequestContextV2
  >

export async function handler(event: WebSocketConnectEvent) {
  const connectionId = event.requestContext.connectionId
  const userId = event.queryStringParameters?.user_id

  try {
    if (!connectionId) {
      return {
        statusCode: 500,
        body: "Missing connectionId",
      }
    }

    if (!userId) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "user_id query parameter is required",
        }),
      }
    }

    await docClient.send(
      new PutCommand({
        TableName: process.env.DYNAMODB_TABLE_NAME!,
        Item: {
          user_id: userId,
          connection_id: connectionId,
          ttl: Math.floor(Date.now() / 1000) + 60 * 60 * 24, // 24 hours from now
        },
      })
    )
    return {
      statusCode: 200,
      body: "Connected",
    }
  } catch (error) {
    console.error("DynamoDB error:", error)

    return {
      statusCode: 500,
      body: "Connection failed",
    }
  }
}