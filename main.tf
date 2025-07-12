module "network" {
  source = "./modules/network"
}

module "security_groups" {
  source          = "./modules/security"
  scalable_vpc_id = module.network.scalable_vpc_id # Pass the VPC ID from the network module
}

module "rds" {
  source                  = "./modules/rds"
  private_rds_subnets_ids = module.network.private_rds_subnet_ids
  rds_sg_id   = module.security_groups.rds_sg_id
  db_username = var.db_username
  db_password = var.db_password
}

module "secrets_manager" {
  source      = "./modules/secrets"
  db_host     = module.rds.db_host
  db_username = var.db_username
  db_password = var.db_password
  db_name     = module.rds.db_name
  depends_on  = [module.rds] # Ensure RDS is created before Secrets Manager
}

module "bastion_host" {
  source            = "./modules/bastion"
  bastion_subnet_id = module.network.public_subnet_ids[1] # Use the second public subnet for the Bastion host
  bastion_sg_id     = module.security_groups.bastion_sg_id
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.network.scalable_vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

module "asg" {
  source                 = "./modules/asg"
  alb_target_group_arns  = [module.alb.alb_target_group_arn]
  private_ec2_subnet_ids = module.network.private_ec2_subnet_ids
  ec2_sg_id              = module.security_groups.ec2_sg_id
  depends_on             = [module.secrets_manager] # Ensure Secrets Manager is created before ASG
}

module "monitoring" {
  source            = "./modules/monitoring"
  alb_arn           = module.alb.alb_arn
  target_group_arn  = module.alb.alb_target_group_arn
}


