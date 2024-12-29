provider "aws" {
  region = "us-east-1" # Adjust the region as needed
}

# DynamoDB Table
resource "aws_dynamodb_table" "registration_table" {
  name         = "registration-table"
  hash_key     = "email"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "email"
    type = "S"
  }
}

# IAM Role
resource "aws_iam_role" "lambda_execution_role" {
  name               = "RegistrationFormRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "lambda.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for DynamoDB
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBAccessPolicy"
  description = "Policy for accessing DynamoDB table"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ],
        Resource = aws_dynamodb_table.registration_table.arn
      }
    ]
  })
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "registration_function" {
  function_name    = "registration-function"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "registration-form.lambda_handler"
  runtime          = "python3.12"
  filename         = "${path.module}/script.zip"
  source_code_hash = filebase64sha256("${path.module}/script.zip")
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.registration_table.name
    }
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "registration_api" {
  name        = "RegistrationAPI"
  description = "API for the registration form"
}

resource "aws_api_gateway_resource" "register_resource" {
  rest_api_id = aws_api_gateway_rest_api.registration_api.id
  parent_id   = aws_api_gateway_rest_api.registration_api.root_resource_id
  path_part   = "register"
}

resource "aws_api_gateway_method" "register_post" {
  rest_api_id   = aws_api_gateway_rest_api.registration_api.id
  resource_id   = aws_api_gateway_resource.register_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.registration_api.id
  resource_id = aws_api_gateway_resource.register_resource.id
  http_method = aws_api_gateway_method.register_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.registration_function.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.registration_api.id
  depends_on  = [aws_api_gateway_integration.lambda_integration]

  stage_name = "prod"
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.registration_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.registration_api.execution_arn}/*/*"
}
