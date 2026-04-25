import { APIGatewayProxyWebsocketEventV2 } from "aws-lambda"
import {
  QueryCommand,
  DeleteCommand,
} from "@aws-sdk/lib-dynamodb"
import { ddbClient } from "./clients"


export async function handler(event: APIGatewayProxyWebsocketEventV2) {

  const connectionId = event.requestContext.connectionId
  const tableName = process.env.DYNAMODB_TABLE_NAME!

  try {
    const result = await ddbClient.send(
      new QueryCommand({
        TableName: tableName,
        IndexName: "connection-id-index",
        KeyConditionExpression: "connection_id = :cid",
        ExpressionAttributeValues: {
          ":cid": connectionId,
        },
      })
    )

    const item = result.Items?.[0]

    if (!item) {
      return { statusCode: 200, body: JSON.stringify({ message: "Disconnected!" }) }
    }

    await ddbClient.send(
      new DeleteCommand({
        TableName: tableName,
        Key: {
          user_id: item.user_id,
          connection_id: item.connection_id,
        },
      })
    )

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Disconnected!" }),
    }

  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Disconnect failed" }),
    }
  }
}