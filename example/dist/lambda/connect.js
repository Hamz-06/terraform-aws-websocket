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
var connect_exports = {};
__export(connect_exports, {
  handler: () => handler
});
module.exports = __toCommonJS(connect_exports);
var import_lib_dynamodb = require("@aws-sdk/lib-dynamodb");
var import_clients = require("./clients");
async function handler(event) {
  const connectionId = event.requestContext.connectionId;
  const userId = event.queryStringParameters?.user_id;
  try {
    if (!connectionId) {
      return {
        statusCode: 500,
        body: "Missing connectionId"
      };
    }
    if (!userId) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "user_id query parameter is required"
        })
      };
    }
    await import_clients.docClient.send(
      new import_lib_dynamodb.PutCommand({
        TableName: process.env.DYNAMODB_TABLE_NAME,
        Item: {
          user_id: userId,
          connection_id: connectionId,
          ttl: Math.floor(Date.now() / 1e3) + 60 * 60 * 24
          // 24 hours from now
        }
      })
    );
    return {
      statusCode: 200,
      body: "Connected"
    };
  } catch (error) {
    console.error("DynamoDB error:", error);
    return {
      statusCode: 500,
      body: "Connection failed"
    };
  }
}
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  handler
});
