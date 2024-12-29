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

1. Open the **API Gateway** service in the AWS Management Console.
2. Create a new REST API:
   - Choose **REST API**.
   - Provide a name for your API (e.g., `RegistrationAPI`).
3. Create a resource named `register`:
   - Under the **Resources** section, click **Create Resource**.
   - Enter `register` as the **Resource Name**.
   - Enable **CORS** for this resource.
4. Add a **POST** method to the `register` resource:
   - Select the `register` resource.
   - Click **Create Method** and choose `POST`.
   - Attach the POST method to the Lambda function (`registration-function`).
   - Save the configuration.
5. Enable **CORS** for the POST method:
   - In the POST method settings, select **Enable CORS**.
   - Save the changes.
6. Deploy the API:
   - Click **Deploy API**.
   - Select **New Stage** or an existing stage (e.g., `prod`).
   - Obtain the **Invoke URL** from the deployment details.
7. Update the `script.js` file in the `Frontend` directory:
   - Open the `script.js` file.
   - Replace the placeholder API URL with the **Invoke URL** obtained from the previous step.





