variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones in the selected region"
  type        = list(string)
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0e72c3f6c08a6fba3"
}

variable "ec2_subnet_id" {
  description = "The index of the subnet to launch the EC2 instance in"
  type        = number
  default     = 0
}

variable "db_port" {
  description = "Database port for MySQL/MariaDB or PostgreSQL"
  type        = number
  default     = 3306 # Change to 5432 if you are using PostgreSQL
}


# Declare the variable for the DB password
variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true # Mark this as sensitive to hide the value in outputs and logs
}


variable "server_port" {
  description = "Server port for webapp"
  type        = number
  default     = 8080 # Change to 5432 if you are using PostgreSQL
}


variable "domain_name" {
  description = "The root domain name for Route 53."
  type        = string
}

variable "desired_capacity" {
  description = "Desired Capacity"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Max instances to launch"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Min instances to launch"
  type        = number
  default     = 3
}

variable "up_threshold" {
  description = "scale_up_alarm threshold."
  type        = number
  default     = 9
}

variable "down_threshold" {
  description = "scale_down_alarm threshold."
  type        = number
  default     = 7
}

variable "key_name" {
  description = "The name of the key pair to use for instances"
  type        = string
  default     = "a07kp"
}

variable "cpu_period" {
  description = "The length of each interval"
  type        = number
  default     = 60
}

variable "cooldown_period" {
  description = "Cooldown period"
  type        = number
  default     = 60
}

variable "eval_period" {
  description = "The number of consecutive intervals for which the metric must meet the criteria."
  type        = number
  default     = 2
}

variable "warmup_period" {
  description = "Warmup period"
  type        = number
  default     = 30
}

variable "hlthchk_interval" {
  description = "Healthcheck interval"
  type        = number
  default     = 30
}

variable "mailgun_api_key" {
  description = "Mailgun API key"
  type        = string
}

variable "mailgun_domain" {
  description = "Mailgun domain"
  type        = string
}

variable "mailgun_from_email" {
  description = "Mailgun from email address"
  type        = string
}

variable "base_url" {
  description = "Email Base URL"
  type        = string
}

variable "lambda_package" {
  description = "Lambda package file path"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "edu.northeastern.csye6225.serverless.Main::handleRequest"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "java21"
}

variable "lambda_timeout" {
  description = "Lambda timeout"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Lambda memory size"
  type        = number
  default     = 512
}

variable "s3_bucket_name" {
  description = "S3 Bucket name"
  type        = string
  default     = "file-storage-csye6225-s3-bucket"
}

variable "aws_autoscaling_group" {
  description = "Autoscaling group name"
  type        = string
  default     = "csye6225_asg"
}

variable "aws_dev_profile" {
  description = "The AWS CLI dev profile to use"
  type        = string
  default     = "dev"
}

variable "aws_demo_profile" {
  description = "The AWS CLI demo profile to use"
  type        = string
  default     = "demo"
}

variable "db_pwd_secret_name" {
  description = "DB Password secret name"
  type        = string
}
variable "email_secret_name" {
  description = "Email secret name"
  type        = string
}

variable "demo_domain_name" {
  description = "The domain name for the demo environment"
  type        = string
}
