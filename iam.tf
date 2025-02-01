# IAM Role for EC2 instance to use S3
resource "aws_iam_role" "s3_user_role" {
  name = "s3_user_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Policy with added S3 permissions
resource "aws_iam_policy" "s3_user_policy" {
  name = "s3_user_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Put*",
          "s3:Delete*"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.file_storage.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.file_storage.bucket}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.email_topic.arn
      }
    ]
  })
}

# Attach the CloudWatch and S3 policy to the role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.s3_user_role.name
  policy_arn = aws_iam_policy.s3_user_policy.arn
}

# IAM Instance Profile for the CloudWatch agent role
resource "aws_iam_instance_profile" "s3_user_profile" {
  name = "s3_user_profile"
  role = aws_iam_role.s3_user_role.name
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.s3_user_role.name
}

resource "aws_iam_policy" "asg_lb_autoscaling_policy" {
  name = "asg_lb_management_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:*",
          "elasticloadbalancing:*",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_asg_lb_policy" {
  policy_arn = aws_iam_policy.asg_lb_autoscaling_policy.arn
  role       = aws_iam_role.s3_user_role.name
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name = "lambda_execution_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect",
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
      # ,
      # {
      #   Effect = "Allow"
      #   Action = [
      #     "sns:Publish"
      #   ]
      #   Resource = aws_sns_topic.email_topic.arn
      # }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_execution_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}


resource "aws_iam_policy" "s3_kms_policy" {
  name = "s3-kms-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.file_storage.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.file_storage.bucket}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:DescribeKey"
        ],
        Resource = aws_kms_key.s3_key.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_kms_policy_attachment" {
  role       = aws_iam_role.s3_user_role.name
  policy_arn = aws_iam_policy.s3_kms_policy.arn
}


