# File: secrets_manager.tf

# The kms_key_id property assigns the KMS key to encrypt secrets stored in AWS Secrets Manager.
# Both the database password and email service credentials are encrypted with the custom KMS key.

# Secrets Manager for Database Password
# The kms_key_id ensures that the custom KMS key is used to encrypt the secret.
resource "aws_secretsmanager_secret" "db_password_secret" {
  name       = var.db_pwd_secret_name
  kms_key_id = aws_kms_key.db_secrets_key.arn # Use the custom KMS key for encryption
}

# The random_password resource is used to generate a secure, random password for the database.
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%!" # Allowed special characters for RDS
}

# random_password.db_password.result dynamically generates a password.
# The secret is stored as a JSON object with the key password.
resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = aws_secretsmanager_secret.db_password_secret.id
  secret_string = jsonencode({
    "password" : random_password.db_password.result
  })
}

# Secrets Manager for Email Service Credentials
# The email credentials (API key, domain, and "from" email) are securely stored in AWS Secrets Manager and encrypted with a custom KMS key.
resource "aws_secretsmanager_secret" "email_service_secret" {
  name       = var.email_secret_name
  kms_key_id = aws_kms_key.email_secrets_key.arn
}

resource "aws_secretsmanager_secret_version" "email_service_version" {
  secret_id = aws_secretsmanager_secret.email_service_secret.id
  secret_string = jsonencode({
    "api_key" : var.mailgun_api_key,
    "domain" : var.mailgun_domain,
    "from_email" : var.mailgun_from_email,
    "base_url" : var.base_url
  })
}

# You can dynamically fetch the password from Secrets Manager using the following data blocks:
# Fetch metadata of the database password secret
data "aws_secretsmanager_secret" "db_password" {
  name = aws_secretsmanager_secret.db_password_secret.name
}

# Fetch the latest version of the secret
# If the secret is created in the same Terraform configuration, add a depends_on clause to ensure it is created before this data block is evaluated:
data "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
  depends_on = [
    # aws_secretsmanager_secret.db_password_secret,
    aws_secretsmanager_secret_version.db_password_version
  ]
}