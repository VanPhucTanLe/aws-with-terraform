# ---------------- Launch Configuration --------------------#
resource "aws_launch_configuration" "launch_configuration" {
  name                        = "launch-configuration-OwnerTL"
  image_id                    = var.ami
  instance_type               = var.instance_type
  security_groups             = [var.security_groups_id[1]]
  key_name                    = var.key_name
  associate_public_ip_address = false

  # #(Already done using the AMI)
  user_data = <<-EOF
  #!/bin/bash
  # Use this for your user data (script from top to bottom)
  # install httpd (Linux 2 version)
  # yum update -y
  # yum install -y httpd
  # systemctl start httpd
  # systemctl enable httpd
  echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
  # user_data = <<-EOF
  # #cloud-config
  # system_info:
  #   default_user:
  #     name: ec2-user
  #     echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  #   EOF

  lifecycle {
    create_before_destroy = true
  }
}


#--------------------- Auto Scalling Group --------------------#
resource "aws_autoscaling_group" "autoscalling_group" {
  name                 = "my-terraform-asg-OwnerTL"
  launch_configuration = var.launch_configuration
  vpc_zone_identifier  = [var.subnet_id[0], var.subnet_id[1]]
  target_group_arns    = [var.target_group_arns]
  health_check_type    = "ELB"
  termination_policies = ["OldestInstance"]



  min_size = var.min_size
  max_size = var.max_size

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ec2-created-by-asg"
    propagate_at_launch = true
  }
}

# ---------------------- ASG Policy ----------------------------#
resource "aws_autoscaling_policy" "asg-policy" {
  name        = "my-terraform-asg-OwnerTL-policy"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
  autoscaling_group_name = aws_autoscaling_group.autoscalling_group.name
}
