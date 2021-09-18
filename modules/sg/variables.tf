variable "vpc_id" {
  type = string
}

variable "custom_cidr_block" {
  type    = list(string)
  default = ["0.0.0.0/0", "174.112.243.212/32"]
}

variable "alb-security-group_id" {
  type = string
}

variable "bastion-host-security-group_id" {
  type = string
}
