output "db_endpoint" {
  value = aws_db_instance.csye6225_db.endpoint
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.file_storage.bucket
  description = "The name of the S3 bucket used for file storage."
}

output "asg_name" {
  value       = aws_autoscaling_group.app_asg.name
  description = "The name of the autoscaling group."
}

output "sns_topic_arn" {
  value       = aws_sns_topic.email_topic.arn
  description = "ARN of the SNS Topic for email verification"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.email_handler.arn
  description = "ARN of the Lambda Function"
}

output "acm_certificate_arn" {
  value       = length(aws_acm_certificate.dev_ssl_cert) > 0 ? aws_acm_certificate.dev_ssl_cert[0].arn : null
  description = "The ARN of the ACM certificate"
}


