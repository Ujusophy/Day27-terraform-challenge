provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west"
  region = "us-west-2"
}

module "vpc_us_east" {
  source          = "./modules/vpc"
  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  public_azs      = ["us-east-1a", "us-east-1b"]
  private_azs     = ["us-east-1a", "us-east-1b"]
  name            = "us-east"
}

module "vpc_us_west" {
  source          = "./modules/vpc"
  providers       = { aws = aws.us-west }  # Corrected alias here
  cidr_block      = "10.1.0.0/16"
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.3.0/24", "10.1.4.0/24"]
  public_azs      = ["us-west-2a", "us-west-2b"]
  private_azs     = ["us-west-2a", "us-west-2b"]
  name            = "us-west"
}

resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc_us_east.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

module "alb_us_east" {
  source            = "./modules/alb"
  providers         = { aws = aws.us-east }  # Ensuring the provider alias is correct
  name              = "us-east"
  vpc_id            = module.vpc_us_east.vpc_id
  public_subnets    = module.vpc_us_east.public_subnet_ids
  security_group_id = aws_security_group.alb_sg.id
}

module "alb_us_west" {
  source            = "./modules/alb"
  providers         = { aws = aws.us-west }  # Ensuring the provider alias is correct
  name              = "us-west"
  vpc_id            = module.vpc_us_west.vpc_id
  public_subnets    = module.vpc_us_west.public_subnet_ids
  security_group_id = aws_security_group.alb_sg.id
}

# Define Target Group for ALB
resource "aws_lb_target_group" "main" {
  name     = "main-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc_us_west.vpc_id
}

resource "aws_security_group" "app_sg" {
  vpc_id = module.vpc_us_east.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

module "asg_us_east" {
  source            = "./modules/asg"
  name              = "us-east"
  ami_id            = "ami-0a0e5d9c7acc336f1" 
  instance_type     = "t2.micro"
  key_name          = "techynurse"
  private_subnets   = module.vpc_us_east.private_subnet_ids
  security_group_id = aws_security_group.app_sg.id
  min_size          = 2
  max_size          = 4
  desired_capacity  = 2
  target_group_arn  = module.alb_us_east.main_target_group_arn
}

module "asg_us_west" {
  source            = "./modules/asg"
  providers         = { aws = aws.us-west }
  name              = "us-west"
  ami_id            = "ami-0c55b159cbfafe1f0" 
  instance_type     = "t2.micro"
  key_name          = "your-key-name"
  private_subnets   = module.vpc_us_west.private_subnet_ids
  security_group_id = aws_security_group.app_sg.id
  min_size          = 2
  max_size          = 4
  desired_capacity  = 2
  target_group_arn  = module.alb_us_west.main_target_group_arn
}

resource "aws_security_group" "rds_sg" {
  vpc_id = module.vpc_us_east.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

module "rds_us_east" {
  source            = "./modules/rds"
  name              = "us-east"
  db_name           = "appdb"
  db_username       = "admin"
  db_password       = "yourpassword"
  primary_az        = "us-east-1a"
  replica_az        = "us-east-1b" 
  security_group_id = aws_security_group.rds_sg.id
  subnet_group      = module.vpc_us_east.db_subnet_group
  subnet_ids        = module.vpc_us_east.private_subnets
}

module "rds_us_west" {
  source            = "./modules/rds"
  providers         = { aws = aws.us-west }
  name              = "us-west"
  db_name           = "appdb"
  db_username       = "admin"
  db_password       = "yourpassword"
  primary_az        = "us-west-2a"
  replica_az        = "us-west-2b"
  security_group_id = aws_security_group.rds_sg.id
  subnet_group      = module.vpc_us_west.db_subnet_group
  create_replica    = true
  subnet_ids        = module.vpc_us_west.private_subnets
}

module "route53_dns" {
  source                      = "./modules/route53"
  zone_id                     = var.zone_id
  domain_name                 = var.domain_name
  elb_us_east_dns             = aws_lb.main.dns_name 
  elb_us_east_zone_id         = aws_lb.main.zone_id        
  elb_us_west_dns             = aws_lb.main_us_west.dns_name
  elb_us_west_zone_id         = aws_lb.main_us_west.zone_id  
  primary_health_check_id     = module.health_check_module.primary_health_check_id
  secondary_health_check_id   = module.health_check_module.secondary_health_check_id
}

module "health_check_module" {
  source                      = "./modules/health_check"
  elb_us_east_dns             = aws_lb.main.dns_name
  elb_us_west_dns             = aws_lb.main_us_west.dns_name
  domain_name                 = var.domain_name
  elb_us_east_zone_id         = aws_lb.main.zone_id
  elb_us_west_zone_id         = aws_lb.main_us_west.zone_id
  zone_id                     = var.zone_id
}

# S3 Replication in us-east-1 to us-west-2
module "s3_replication" {
  source = "./modules/s3"
  name   = "app-static-assets"
}

module "cloudwatch_alarms" {
  source             = "./modules/cloudwatch"
  name               = "app-monitoring"
  ec2_instance_id    = data.aws_instances.app_instances.ids[0]
  elb_name           = module.alb_us_east.dns_name 
  rds_instance_id    = module.rds_us_east.primary_rds_instance_id
}

data "aws_instances" "app_instances" {
  instance_tags = {
    Name = "first-app-instance"
  }
}
