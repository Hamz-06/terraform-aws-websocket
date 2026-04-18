import {
  PostToConnectionCommand,
} from "@aws-sdk/client-apigatewaymanagementapi"

import {
  APIGatewayProxyEventV2,
  APIGatewayProxyResultV2,
} from "aws-lambda"
import {
  QueryCommand,
  DeleteCommand,
} from "@aws-sdk/lib-dynamodb"
import { ddbClient, wsClient } from "./clients"


const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME!

export async function handler(
  event: APIGatewayProxyEventV2
): Promise<APIGatewayProxyResultV2> {

  console.log("Received event:", JSON.stringify(event, null, 2))

  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Missing body" }),
    }
  }

  const { user_id, message } = JSON.parse(event.body)

  if (!user_id || !message) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "user_id and message required",
      }),
    }
  }


  const result = await ddbClient.send(
    new QueryCommand({
      TableName: TABLE_NAME,
      KeyConditionExpression: "user_id = :uid",
      ExpressionAttributeValues: {
        ":uid": user_id,
      },
    })
  )

  const connections = result.Items ?? []

  await Promise.all(
    connections.map(async (item) => {
      const connectionId = item.connection_id;
      await sendConnectionMessage(connectionId, user_id, message)
    })
  )

  return {
    statusCode: 200,
    body: JSON.stringify({
      success: true,
      deliveredTo: connections.length,
    }),
  }
}

async function sendConnectionMessage(connectionId: string, userId: string, message: string) {
  try {
    await wsClient.send(
      new PostToConnectionCommand({
        ConnectionId: connectionId,
        Data: Buffer.from(
          JSON.stringify({
            type: "notification",
            message,
          })
        ),
      })
    )
  } catch (err: unknown) {
    if (err instanceof Error && err.name === "GoneException") {
      await ddbClient.send(
        new DeleteCommand({
          TableName: TABLE_NAME,
          Key: {
            user_id: userId,
            connection_id: connectionId,
          },
        })
      )
    }
  }
}