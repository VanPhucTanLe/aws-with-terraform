# ---------------Instance------------------- #
variable "ec2_count" {
  type    = string
  default = "1"
}

variable "ami" {
  description = "AMI of the EC2 instance"
  type        = string
  default     = "ami-0999ed5ee61a5b692"
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

# variable "availability_zone" {
#   description = "AZ of the EC2 instance"
#   type        = string
# }

variable "public-subnet_id" {
  type = string
}

# variable "private-subnet_id" {
#   type = string
# }

variable "bastion-host-security-group_id" {
  type = string
}

# variable "ec2-security-group_id" {
#   type = string
# }

variable "key_pair" {
  type    = string
  default = "DOU-KP-TanLe-us-west-1"
}
