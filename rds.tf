resource "aws_db_parameter_group" "db_param_group" {
  name        = "custom-db-param-group"
  family      = "mysql8.0" # Adjust this depending on the DB engine and version you're using
  description = "Custom parameter group for MySQL"

  # Example parameters, you can adjust these based on your needs
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "max_connections"
    value = "200"
  }

  tags = {
    Name = "custom-db-param-group"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db-subnet-group"
  description = "Private subnet group for RDS"

  subnet_ids = aws_subnet.private[*].id # Use all private subnets dynamically

  tags = {
    Name = "db-subnet-group"
  }
}


# defining RDS instance
resource "aws_db_instance" "csye6225_db" {
  identifier        = "csye6225"
  allocated_storage = 20            # Storage in GB
  engine            = "mysql"       # Use "postgres" for PostgreSQL, or "mariadb" for MariaDB
  instance_class    = "db.t3.micro" # Cheapest instance, adjust as needed
  db_name           = "csye6225"
  username          = "csye6225"
  #password               = var.db_password                            # Store this in a Terraform variable
  #password               = random_password.db_password.result # Pass the generated password
  #password               = local.db_password                          # Use password fetched from Secrets Manager
  password               = jsondecode(data.aws_secretsmanager_secret_version.db_password_version.secret_string)["password"]
  parameter_group_name   = aws_db_parameter_group.db_param_group.name # Use the custom parameter group
  publicly_accessible    = false                                      # Must be set to false, making it private
  vpc_security_group_ids = [aws_security_group.db_sg.id]              # Attach the DB security group
  kms_key_id             = aws_kms_key.rds_key.arn                    # Using KMS key applies the custom KMS key to encrypt RDS data at rest.
  multi_az               = false                                      # No Multi-AZ deployment
  skip_final_snapshot    = true                                       # Skip creating a final snapshot when the DB is deleted
  storage_encrypted      = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name # Attach to private subnets

  tags = {
    Name = "csye6225-db-instance"
  }
}


