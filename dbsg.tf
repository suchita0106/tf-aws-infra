resource "aws_security_group" "db_sg" {
  name        = "db_security_group"
  description = "Security group for the RDS database"
  vpc_id      = aws_vpc.csye6225.id # Replace this with your VPC's ID

  # Inbound rule to allow traffic on MySQL/MariaDB port 3306 or PostgreSQL port 5432
  ingress {
    description     = "Allow MySQL/MariaDB/PostgreSQL traffic from the app security group"
    from_port       = var.db_port # This is the port for your chosen DB (3306 or 5432)
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id] # Source is the App Security Group
  }

  # Outbound rule to allow all traffic (RDS usually needs outbound access to the internet)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # This allows outbound traffic to any IP
  }

  tags = {
    Name = "db_security_group"
  }
}
