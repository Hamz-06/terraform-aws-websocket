
Terraform module to build a WebSocket API using API Gateway and Lambda functions.

This websocket module is specifically designed to decouple the connection management logic in microservice architecture. We connect to the websocket API
and have the connection stored by AWS and we save the connection ID in a DynamoDB table (not implemented yet). We can then make a http request to a http endpoint with the connection ID and message we want to send to the client. Future improvements will allow you to send the user ID instead of the connection ID and we will look up the connection ID in the DynamoDB table and send the message to all connections for that user.

Lambda functions created: 
- Connect handler
- Disconnect handler

producer lambda handlers receives these environment variables by default:

*Environment variables*
RESERVED
- AWS_REGION 
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
- AWS_LAMBDA_FUNCTION_NAME
- AWS_LAMBDA_FUNCTION_MEMORY_SIZE
- AWS_LAMBDA_FUNCTION_TIMEOUT
- AWS_LAMBDA_LOG_GROUP_NAME
- AWS_LAMBDA_LOG_STREAM_NAME

- WS_DOMAIN_NAME -> domain name of the WebSocket API (123.execute-api.us-east-1.amazonaws.com)
- WS_STAGE -> stage name of the WebSocket API (dev)



*Roadmap*:
- Add dynamo DB table for connection management, something like this: Allows for multiple connections per user
Table name: websocket-connections

user_id (partition key) -> connectionId (sort key)

Example: 
user1 -> conn1

user2 -> conn2

user3 -> conn3
user3 -> conn4
user3 -> conn5

- Add a way to run npm run build before pushing the code and before terraform apply