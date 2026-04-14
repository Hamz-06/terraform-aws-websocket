import {
  ApiGatewayManagementApiClient,
  PostToConnectionCommand,
} from "@aws-sdk/client-apigatewaymanagementapi";

import {
  APIGatewayProxyEventV2,
  APIGatewayProxyResultV2,
} from "aws-lambda";

export async function handler(
  event: APIGatewayProxyEventV2
): Promise<APIGatewayProxyResultV2> {
  let url: string;
  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Missing body" }),
    };
  }

  const body = JSON.parse(event.body);

  const connectionId: string | undefined = body.connectionId;

  if (!connectionId) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "connectionId required" }),
    };
  }

  const domainName = process.env.WS_DOMAIN_NAME!;
  const stage = process.env.WS_STAGE!;

  url = `https://${domainName}/${stage}`
  const client = new ApiGatewayManagementApiClient({
    region: process.env.AWS_REGION,
    endpoint: url,
  });

  try {
    const command = new PostToConnectionCommand({
      ConnectionId: connectionId,
      Data: Buffer.from(
        JSON.stringify({
          type: "notification",
          message: "Hello client",
        })
      ),
    });
    await client.send(command);

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true }),
    };

  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to send message" }),
    };
  }
}