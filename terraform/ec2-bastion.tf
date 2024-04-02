# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  name_prefix = "bastion-sg-"

  vpc_id = aws_vpc.my_vpc.id

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

# Bastion Host
resource "aws_instance" "bastion" {
  ami             = "ami-0c101f26f147fa7fd"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  key_name        = "key"
  security_groups = [aws_security_group.bastion_sg.name]

  tags = {
    Name = "bastion-host"
  }
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
