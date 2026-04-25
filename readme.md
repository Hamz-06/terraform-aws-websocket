
# Terraform AWS WebSocket Module

[![Module Version](https://img.shields.io/github/v/release/Hamz-06/terraform-aws-websocket?label=module%20version)](https://github.com/Hamz-06/terraform-aws-websocket/releases)

Build a WebSocket API on AWS using API Gateway, Lambda, and DynamoDB.

## Overview

This module is designed to decouple WebSocket connection management in a microservice architecture.

- Clients connect to the WebSocket API.
- Connection data is stored in DynamoDB.
- A producer endpoint accepts a `user_id` and `message`.
- The producer Lambda looks up all active connections for that user and fans out the message.

## Lambda Handlers

- Connect handler
- Disconnect handler
- Producer handler
- Default handler

## Environment Variables

The producer Lambda handler receives the following environment variables.

### Reserved

- AWS_REGION
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
- AWS_LAMBDA_FUNCTION_NAME
- AWS_LAMBDA_FUNCTION_MEMORY_SIZE
- AWS_LAMBDA_FUNCTION_TIMEOUT
- AWS_LAMBDA_LOG_GROUP_NAME
- AWS_LAMBDA_LOG_STREAM_NAME

### Custom

- WS_DOMAIN_NAME: WebSocket API domain name (example: `123.execute-api.us-east-1.amazonaws.com`)
- WS_STAGE: WebSocket API stage (example: `dev`)
- DYNAMODB_TABLE_NAME: DynamoDB table name for storing connections (example: `websocket-connections`)
- ENVIRONMENT: Deployment environment (example: `dev`, `prod`, `local`)

## How To Run The Example

1. Move to the example folder.

```bash
cd example
```

2. Install dependencies and build Lambda functions.

```bash
npm install
npm run build
```

3. Deploy infrastructure.

```bash
terraform apply
```

4. Connect to the WebSocket API.

```text
wss://rug2.execute-api.us-east-1.amazonaws.com/dev?user_id=123
```

5. Send a POST request to the producer endpoint with this payload.

```json
{
  "user_id": "123",
  "message": "Hello, World!"
}
```

6. Confirm the message appears in your WebSocket client.
7. Repeat with a different `user_id` to target another user.

## Connection Table Model

Table name: `websocket-connections`

- Partition key: `user_id`
- Sort key: `connection_id`

Example records:

```text
user1 -> conn1
user2 -> conn2
user3 -> conn3
user3 -> conn4
user3 -> conn5
```

## How to commit 

Follow this link  [How to commit](https://semantic-release.gitbook.io/semantic-release#commit-message-format) 