output "vpc_id" {
  description = "Output vpc_id after creating the vpc"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "vpc_sg" {
  value = aws_vpc.main.default_security_group_id
}

output "internet-gateway_id" {
  description = "value"
  value       = aws_internet_gateway.gw.id
}

output "nat-gateway_id" {
  description = "value"
  value       = aws_nat_gateway.nat.id
}


output "public_subnets" {
  description = "value"
  value       = aws_subnet.public-subnet.*.id
}

output "private_subnets" {
  description = "value"
  value       = aws_subnet.private-subnet.*.id
}

output "public-route-table_id" {
  description = "value"
  value       = aws_route_table.public-route-table.id
}

output "private-route-table_id" {
  description = "value"
  value       = aws_route_table.private-route-table.id
}



