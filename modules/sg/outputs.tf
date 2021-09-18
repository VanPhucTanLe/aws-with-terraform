output "bastion-host-security-group_id" {
  value = aws_security_group.bastion-host-security-group.id
}

output "alb-security-group_id" {
  value = aws_security_group.alb-security-group.id
}

output "ec2-security-group_id" {
  value = aws_security_group.ec2-security-group.id
}
