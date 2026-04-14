import { APIGatewayProxyWebsocketEventV2 } from "aws-lambda"

export async function handler(event: APIGatewayProxyWebsocketEventV2) {

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Connected!" }),
  }
}
