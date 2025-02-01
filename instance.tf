# Launch Template for Auto-Scaling Group
resource "aws_launch_template" "app_template" {
  name_prefix   = "app-launch-template"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.s3_user_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      kms_key_id            = aws_kms_key.ec2_key.arn
      encrypted             = true
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo echo "DB_USERNAME=csye6225" >> /opt/webapp/.env
              sudo echo "DB_PASSWORD=${jsondecode(data.aws_secretsmanager_secret_version.db_password_version.secret_string)["password"]}" >> /opt/webapp/.env
              sudo echo "DB_URL=jdbc:mysql://${aws_db_instance.csye6225_db.endpoint}/csye6225?createDatabaseIfNotExist=true" >> /opt/webapp/.env
              sudo echo "SERVER_PORT=${var.server_port}"  >> /opt/webapp/.env
              sudo echo "AWS_REGION=${var.aws_region}"  >> /opt/webapp/.env
              sudo echo "AWS_S3_BUCKET=${aws_s3_bucket.file_storage.bucket}"  >> /opt/webapp/.env
              sudo echo "TOPIC_ARN=${aws_sns_topic.email_topic.arn}"  >> /opt/webapp/.env
              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
              sudo systemctl daemon-reload
              sudo systemctl enable amazon-cloudwatch-agent
              sudo systemctl start amazon-cloudwatch-agent
              sudo systemctl restart webapp.service
            EOF
  )

  tags = {
    Name = "webapp-launch-template"
  }
}

# Auto-Scaling Group Configuration
resource "aws_autoscaling_group" "app_asg" {
  #name                = "csye6225_asg_${random_uuid.generated_id.result}"
  name                = var.aws_autoscaling_group
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = aws_subnet.public[*].id

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  target_group_arns       = [aws_lb_target_group.app_tg.arn]
  default_instance_warmup = var.warmup_period

  tag {
    key                 = "Name"
    value               = "csye6225_asg"
    propagate_at_launch = true
  }
}
