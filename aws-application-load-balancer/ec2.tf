resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "HTTP from the ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "web_key" {
  key_name   = "web-key"
  public_key = file("./my-key.pub")
}

# Latest Ubuntu 24.04 AMI in the current region (AMI IDs differ per region)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Four servers in two groups. Each group gets its own target group.
# subnet_index picks the public subnet (and so the AZ), spreading each group over both AZs.
locals {
  servers = {
    web-1 = { group = "web", subnet_index = 0 }
    web-2 = { group = "web", subnet_index = 1 }
    api-1 = { group = "api", subnet_index = 0 }
    api-2 = { group = "api", subnet_index = 1 }
  }
}

resource "aws_instance" "this" {
  for_each = local.servers

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnets[each.value.subnet_index].id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.web_key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install apache2 -y
              HOSTNAME=$(hostname)
              IP_ADDRESS=$(hostname -I | cut -d' ' -f1)
              PAGE="<html><head><title>Server Details</title></head><body><h1>Server Details</h1><p><strong>Group:</strong> ${each.value.group}</p><p><strong>Hostname:</strong> $HOSTNAME</p><p><strong>IP Address:</strong> $IP_ADDRESS</p></body></html>"
              echo "$PAGE" | tee /var/www/html/index.html
              systemctl restart apache2
              EOF

  tags = {
    Name  = each.key
    Group = each.value.group
  }
}