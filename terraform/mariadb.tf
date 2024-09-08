resource "aws_instance" "mariadb" {
  ami           = var.ami_id
  instance_type = var.db_instance_type
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.db.id]

  tags = {
    Name = "${var.project_name}-mariadb"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y mariadb-server
              sudo systemctl start mariadb
              sudo systemctl enable mariadb
              sudo mysql -e "CREATE DATABASE IF NOT EXISTS employee_management;"
              sudo mysql -e "CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY '${var.db_password}';"
              sudo mysql -e "GRANT ALL PRIVILEGES ON employee_management.* TO 'user'@'%';"
              sudo mysql -e "FLUSH PRIVILEGES;"
              EOF
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for MariaDB server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.main.id]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.main.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}