# 9. Create an Ubuntu Server and install/enable apache2
resource "aws_instance" "public_instance" {
  #count             = var.ec2_count
  ami           = var.ami
  instance_type = var.instance_type
  #availability_zone = var.availability_zone
  subnet_id       = var.public-subnet_id
  security_groups = [var.bastion-host-security-group_id]
  key_name        = var.key_pair

  # network_interface {
  #   device_index         = 0
  #   network_interface_id = aws_network_interface.nic.id
  # }

  #security_security_groups = 
  #subnet_id                   = aws_subnet.publicSubnet.id
  #associate_public_ip_address = "true"

  tags = {
    Name = "Bastion Host - OwnerTL"
  }
}


# resource "aws_instance" "private_instance" {
#   #count             = var.ec2_count
#   ami               = var.ami
#   instance_type     = var.instance_type
#   availability_zone = var.availability_zone
#   subnet_id         = var.private-subnet_id
#   security_groups   = [var.ec2-security-group_id]
#   key_name          = var.key_pair

#   #security_security_groups = 
#   #subnet_id                   = aws_subnet.publicSubnet.id
#   #associate_public_ip_address = "true"

#   tags = {
#     Name = "PrivateEC2 - TL"
#   }
# }
