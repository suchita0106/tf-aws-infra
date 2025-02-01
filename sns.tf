resource "aws_sns_topic" "email_topic" {
  name = "email-verification-topic"
}

resource "aws_lambda_permission" "allow_sns_invocation" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_handler.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.email_topic.arn
}

resource "aws_sns_topic_subscription" "email_lambda_subscription" {
  topic_arn = aws_sns_topic.email_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_handler.arn
}
