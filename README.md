# AWS-Serverless-Registration-Form

The AWS Serverless Registration Form project demonstrates how to build a scalable and efficient serverless application using AWS services. It provides a robust foundation for developers implementing user registration functionality while minimizing operational overhead.

---

## Steps to Build the Application Using the AWS Console

### Step 1: Create DynamoDB Table

1. Navigate to the DynamoDB service in the AWS Management Console.
2. Create a table with the following details:
   - **Table Name**: `registration-table`
   - **Partition Key**: `email`

---

### Step 2: Create IAM Role for Lambda Function

1. Go to the IAM service and create a new role.
   - **IAM Role Name**: `RegistrationFormRole`
   - Attach the following permissions:
     - `CloudWatch Full Access`
     - `DynamoDB Full Access`

2. Use the following JSON policy to grant permissions specific to the DynamoDB table:

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Sid": "registrationTablePolicy",
               "Effect": "Allow",
               "Action": [
                   "dynamodb:PutItem",
                   "dynamodb:DeleteItem",
                   "dynamodb:GetItem",
                   "dynamodb:Scan",
                   "dynamodb:Query",
                   "dynamodb:UpdateItem"
               ],
               "Resource": "<Use_the_DynamoDB_table_ARN>"
           }
       ]
   }


### Step 3: Create Lambda Function
Navigate to the Lambda service and create a new function.

```sh
Function Name: registration-function
Runtime: Python 3.12
```

### Step 4: copy Lambda Function

Clone the repository and navigate to the directory containing the Lambda function code:

```sh
cd AWS-Serverless-Registration-Form/LambdaFun
```
Copy the function code to your Lambda function in the AWS console.


### Step 5: Create API Gateway and Enable CORS

1- Open the API Gateway service and create a new REST API.
2- Create a resource named register and enable CORS for this resource.
3- Add a POST method to the register resource and attach it to the Lambda function.
4- Enable CORS for the POST method.
5- Deploy the API and obtain the Invoke URL.
6- Update the script.js file in the Frontend directory with the Invoke URL.




