provider "aws" {
  region = "eu-central-1"
}

# SSH Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "mern-key"
  public_key = file("/home/nouf/.ssh/id_rsa.pub")  # Adjust if your username is different
}

# Security Group
resource "aws_security_group" "mern_sg" {
  name        = "mern-sg"
  description = "Allow SSH, HTTP, and app port"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

# EC2 Instance
resource "aws_instance" "mern_backend" {
  ami           = "ami-04e601abe3e1a910f"  # Ubuntu 22.04 LTS for eu-central-1 (Frankfurt)
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.mern_sg.name]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "MERN-Backend"
  }
}
