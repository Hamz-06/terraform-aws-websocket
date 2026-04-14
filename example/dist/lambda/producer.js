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
async function handler(event) {
  let url;
  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Missing body" })
    };
  }
  const body = JSON.parse(event.body);
  const connectionId = body.connectionId;
  if (!connectionId) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "connectionId required" })
    };
  }
  const domainName = process.env.WS_DOMAIN_NAME;
  const stage = process.env.WS_STAGE;
  url = `https://${domainName}/${stage}`;
  const client = new import_client_apigatewaymanagementapi.ApiGatewayManagementApiClient({
    region: process.env.AWS_REGION,
    endpoint: url
  });
  try {
    const command = new import_client_apigatewaymanagementapi.PostToConnectionCommand({
      ConnectionId: connectionId,
      Data: Buffer.from(
        JSON.stringify({
          type: "notification",
          message: "Hello client"
        })
      )
    });
    await client.send(command);
    return {
      statusCode: 200,
      body: JSON.stringify({ success: true })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to send message" })
    };
  }
}
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  handler
});
