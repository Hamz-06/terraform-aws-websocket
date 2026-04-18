
How to run the example:

Install dependencies and build the Lambda function:

1. NPM install 
2. NPM run build
3. Terraform apply
4. Connect to the websocket API -> wss://rug2.execute-api.us-east-1.amazonaws.com/dev?user_id=123
5. Produce messages by sending a POST request to the producer Lambda function with the following body:
   {
     "user_id": "123",
     "message": "Hello, World!"
   }
6. You should see the message in the websocket client. You can also connect with a different user_id and send messages to that user.
