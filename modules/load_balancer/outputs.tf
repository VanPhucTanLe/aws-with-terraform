output "target_group" {
  value = aws_lb_target_group.target-group
}

output "load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.target-group.arn
}
