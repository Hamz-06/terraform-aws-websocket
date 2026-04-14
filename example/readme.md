
How to run the example:

Install dependencies and build the Lambda function:

1. NPM install 
2. NPM run build
3. Terraform apply
4. Connect to the websocket API -> wss://rug2.execute-api.us-east-1.amazonaws.com/dev
5. Get the connection ID from the log (soon to be added to the dynamo DB table)
6. Send a message to the HTTP api gateway -> curl -X POST https://nywt0p1wrk.execute-api.us-east-1.amazonaws.com/invoke -d '{"connectionId": "123"}'
