# 6. Create SGs
resource "aws_security_group" "bastion-host-security-group" {
  name        = "allow_traffic_bastionhost"
  description = "allow_traffic_bastionhost"
  vpc_id      = var.vpc_id
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.custom_cidr_block[1]]
    ipv6_cidr_blocks = [var.custom_cidr_block[1]]
  }

  egress {
    description      = "Allow All"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.custom_cidr_block[0]]
    ipv6_cidr_blocks = [var.custom_cidr_block[0]]
  }


  tags = {
    Name = "Bastion Host Security Group"
  }
}

resource "aws_security_group" "alb-security-group" {
  name        = "allow_traffic_alb"
  description = "allow_traffic_alb"
  vpc_id      = var.vpc_id
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.custom_cidr_block[1]]
    ipv6_cidr_blocks = [var.custom_cidr_block[1]]
  }

  egress {
    description      = "Allow All"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.custom_cidr_block[0]]
    ipv6_cidr_blocks = [var.custom_cidr_block[0]]
  }

  tags = {
    Name = "ALB Security Group"
  }
}


resource "aws_security_group" "ec2-security-group" {
  name        = "allow_traffic_ec2"
  description = "allow_traffic_ec2"
  vpc_id      = var.vpc_id
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb-security-group_id] #aws_lb.alb.security_groups
    # cidr_blocks      = [aws_security_group.alb-security-group]
    # ipv6_cidr_blocks = [aws_security_group.alb-security-group]
  }
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion-host-security-group_id]
  }

  egress {
    description      = "Allow All"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.custom_cidr_block[0]]
    ipv6_cidr_blocks = [var.custom_cidr_block[0]]
  }


  tags = {
    Name = "EC2 Security Group"
  }
}
