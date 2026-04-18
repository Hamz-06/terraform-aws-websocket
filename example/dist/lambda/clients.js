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
var clients_exports = {};
__export(clients_exports, {
  ddbClient: () => ddbClient,
  docClient: () => docClient,
  wsClient: () => wsClient
});
module.exports = __toCommonJS(clients_exports);
var import_client_apigatewaymanagementapi = require("@aws-sdk/client-apigatewaymanagementapi");
var import_client_dynamodb = require("@aws-sdk/client-dynamodb");
var import_lib_dynamodb = require("@aws-sdk/lib-dynamodb");
const ddbClient = new import_client_dynamodb.DynamoDBClient({
  region: process.env.AWS_REGION
});
const docClient = import_lib_dynamodb.DynamoDBDocumentClient.from(ddbClient);
const wsClient = new import_client_apigatewaymanagementapi.ApiGatewayManagementApiClient({
  region: process.env.AWS_REGION,
  endpoint: `https://${process.env.WS_DOMAIN_NAME}/${process.env.WS_STAGE}`
});
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  ddbClient,
  docClient,
  wsClient
});
