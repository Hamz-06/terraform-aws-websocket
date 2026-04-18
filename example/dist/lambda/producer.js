"use strict";
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);
var producer_exports = {};
__export(producer_exports, {
  handler: () => handler
});
module.exports = __toCommonJS(producer_exports);
var import_client_apigatewaymanagementapi = require("@aws-sdk/client-apigatewaymanagementapi");
var import_lib_dynamodb = require("@aws-sdk/lib-dynamodb");
var import_clients = require("./clients");
const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME;
async function handler(event) {
  console.log("Received event:", JSON.stringify(event, null, 2));
  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Missing body" })
    };
  }
  const { user_id, message } = JSON.parse(event.body);
  if (!user_id || !message) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "user_id and message required"
      })
    };
  }
  const result = await import_clients.ddbClient.send(
    new import_lib_dynamodb.QueryCommand({
      TableName: TABLE_NAME,
      KeyConditionExpression: "user_id = :uid",
      ExpressionAttributeValues: {
        ":uid": user_id
      }
    })
  );
  const connections = result.Items ?? [];
  await Promise.all(
    connections.map(async (item) => {
      const connectionId = item.connection_id;
      await sendConnectionMessage(connectionId, user_id, message);
    })
  );
  return {
    statusCode: 200,
    body: JSON.stringify({
      success: true,
      deliveredTo: connections.length
    })
  };
}
async function sendConnectionMessage(connectionId, userId, message) {
  try {
    await import_clients.wsClient.send(
      new import_client_apigatewaymanagementapi.PostToConnectionCommand({
        ConnectionId: connectionId,
        Data: Buffer.from(
          JSON.stringify({
            type: "notification",
            message
          })
        )
      })
    );
  } catch (err) {
    if (err instanceof Error && err.name === "GoneException") {
      await import_clients.ddbClient.send(
        new import_lib_dynamodb.DeleteCommand({
          TableName: TABLE_NAME,
          Key: {
            user_id: userId,
            connection_id: connectionId
          }
        })
      );
    }
  }
}
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  handler
});
