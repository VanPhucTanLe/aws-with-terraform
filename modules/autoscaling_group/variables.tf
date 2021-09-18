variable "ami" {
  type    = string
  default = "ami-0999ed5ee61a5b692"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "security_groups_id" {
  type = list(string)
}

variable "key_name" {
  type    = string
  default = "DOU-KP-TanLe-us-west-1"
}

variable "launch_configuration" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "target_group_arns" {
  type = string
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}
