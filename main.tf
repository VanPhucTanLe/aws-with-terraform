locals {
  name   = "my-sql"
  region = "eu-west-1"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "vpc" {
  source              = ".//modules/vpc"
  vpc_id              = module.vpc.vpc_id
  allocation_id       = "eipalloc-4b9f3b4c"
  internet-gateway_id = module.vpc.internet-gateway_id
  nat-gateway_id      = module.vpc.nat-gateway_id

  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  #count             = 2

  public-route-table_id  = module.vpc.public-route-table_id
  private-route-table_id = module.vpc.private-route-table_id
}

module "ec2" {
  source                         = ".//modules/ec2"
  instance_type                  = "t2.micro"
  public-subnet_id               = module.vpc.public_subnets[0]
  bastion-host-security-group_id = module.sg.bastion-host-security-group_id
}

module "sg" {
  source                         = ".//modules/sg"
  vpc_id                         = module.vpc.vpc_id
  alb-security-group_id          = module.sg.alb-security-group_id
  bastion-host-security-group_id = module.sg.bastion-host-security-group_id
}

module "load_balancer" {
  source             = ".//modules/load_balancer"
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups_id = tolist([module.sg.alb-security-group_id, module.sg.ec2-security-group_id])
  # subnet_id          = tolist([module.vpc.public-subnet_id, module.vpc.private-subnet_id])
  subnet_id         = tolist([module.vpc.public_subnets[0], module.vpc.public_subnets[1]])
  load_balancer_arn = module.load_balancer.load_balancer_arn
  port              = 80
  protocol          = "HTTP"
  target_group_arn  = module.load_balancer.target_group_arn
}

module "autoscaling_group" {
  #count              = 2
  source             = ".//modules/autoscaling_group"
  ami                = "ami-0999ed5ee61a5b692"
  instance_type      = "t2.micro"
  security_groups_id = tolist([module.sg.alb-security-group_id, module.sg.ec2-security-group_id])
  key_name           = "DOU-KP-TanLe-us-west-1"

  launch_configuration = module.autoscaling_group.launch_configuration.name
  #subnet_id            = tolist([module.vpc.public-subnet_id, module.vpc.private-subnet_id])
  subnet_id         = tolist([module.vpc.private_subnets[0], module.vpc.private_subnets[1]])
  target_group_arns = module.load_balancer.target_group.arn

  min_size = 2
  max_size = 5
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.4.0"


  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 5

  name     = "mydbownertl"
  username = "user"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.vpc.vpc_sg]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
