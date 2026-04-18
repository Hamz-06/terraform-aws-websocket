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
var disconnect_exports = {};
__export(disconnect_exports, {
  handler: () => handler
});
module.exports = __toCommonJS(disconnect_exports);
var import_lib_dynamodb = require("@aws-sdk/lib-dynamodb");
var import_clients = require("./clients");
async function handler(event) {
  const connectionId = event.requestContext.connectionId;
  const tableName = process.env.DYNAMODB_TABLE_NAME;
  try {
    const result = await import_clients.ddbClient.send(
      new import_lib_dynamodb.QueryCommand({
        TableName: tableName,
        IndexName: "connection-id-index",
        KeyConditionExpression: "connection_id = :cid",
        ExpressionAttributeValues: {
          ":cid": connectionId
        }
      })
    );
    const item = result.Items?.[0];
    if (!item) {
      return { statusCode: 200, body: JSON.stringify({ message: "Disconnected!" }) };
    }
    await import_clients.ddbClient.send(
      new import_lib_dynamodb.DeleteCommand({
        TableName: tableName,
        Key: {
          user_id: item.user_id,
          connection_id: item.connection_id
        }
      })
    );
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Disconnected!" })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Disconnect failed" })
    };
  }
}
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  handler
});
