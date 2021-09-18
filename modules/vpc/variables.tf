variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_id" {
  type = string
}

variable "allocation_id" {
  type    = string
  default = "eipalloc-4b9f3b4c"
}

variable "azs" {
  type    = list(string)
  default = ["us-west-1a", "us-west-1b"]
}

variable "internet-gateway_id" {
  type = string
}

variable "nat-gateway_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public-route-table_id" {
  type = string
}

variable "private-route-table_id" {
  type = string
}


variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "custom_cidr_block" {
  type    = list(string)
  default = ["0.0.0.0/0", "174.112.243.212/32"]
}
