# -------------------Target Groups--------------------- #
resource "aws_lb_target_group" "target-group" {
  health_check {
    interval            = 5
    path                = "/"
    protocol            = "HTTP"
    timeout             = 4
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  name             = "my-target-group-OwnerTL"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "instance"
  vpc_id           = var.vpc_id
}

# ----------------Attach EC2 to TGs--------------------- #
# resource "aws_alb_target_group_attachment" "ec2_attach" {
#   target_group_arn = aws_lb_target_group.target-group.arn
#   target_id        = var.public_instance_id
#   port             = 80
# }


# -------------------Load Balancers--------------------- #
resource "aws_lb" "alb" {
  name               = "ALB-OwnerTL"
  internal           = false
  load_balancer_type = var.load_balancer_type
  ip_address_type    = var.ip_address_type
  security_groups    = [var.security_groups_id[0]]
  subnets            = [var.subnet_id[0], var.subnet_id[1]]

  enable_deletion_protection = false

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Name = "production-ALB-OwnerTL"
  }
}


# -------------------AWS_LB_Listener-------------------- #
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  default_action {
    target_group_arn = var.target_group_arn #aws_lb_target_group.target-group.arn
    type             = "forward"
  }
}
