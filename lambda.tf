resource "aws_lambda_function" "email_handler" {
  function_name = "emailHandlerFunction"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size

  # Path to your compiled JAR file
  filename         = var.lambda_package
  source_code_hash = filebase64sha256(var.lambda_package)

  environment {
    variables = {
      #   DB_URL          = "jdbc:mysql://${aws_db_instance.csye6225_db.endpoint}/csye6225?createDatabaseIfNotExist=true"
      #   DB_USERNAME     = "csye6225"
      #   DB_PASSWORD     = var.db_password
      # MAILGUN_API_KEY = var.mailgun_api_key
      # MAILGUN_DOMAIN  = var.mailgun_domain
      # FROM_EMAIL      = var.mailgun_from_email
      # BASE_URL        = var.base_url
      EMAIL_SECRET_NAME = var.email_secret_name
      AWS_REGION_NAME   = var.aws_region
    }
  }
}

# The aws_iam_policy grants the Lambda function permissions to access the email credentials stored in Secrets Manager.
# The policy is attached to the Lambda execution role.

resource "aws_iam_policy" "lambda_secrets_policy" {
  name = "LambdaSecretsAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = aws_secretsmanager_secret.email_service_secret.arn
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource = aws_kms_key.email_secrets_key.arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_secrets_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_secrets_policy.arn
}

