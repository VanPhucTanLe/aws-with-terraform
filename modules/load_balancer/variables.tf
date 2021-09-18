variable "vpc_id" {
  type = string
}

# variable "public_instance_id" {
#   type = string
# }

variable "security_groups_id" {
  type = list(string)
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "ip_address_type" {
  type    = string
  default = "ipv4"
}

variable "load_balancer_arn" {
  type = string
}

variable "port" {
  type    = number
  default = 80
}

variable "protocol" {
  type    = string
  default = "HTTP"
}

variable "target_group_arn" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}
