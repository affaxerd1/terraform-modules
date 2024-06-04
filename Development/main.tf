//configure aws provider
provider "aws" {
  region = var.region
  profile = "terraform-user"
}

//create vpc
module "vpc" {
  source = "../modules/vpc"
  region = var.region
  project_name = var.project_name
  vpc_cidr = var.vpc_cidr
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr= var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_subnet_az2_cidr=var.private_data_subnet_az2_cidr
  private_data_subnet_az1 = var.private_data_subnet_az1_cidr
  private_data_subnet_az2 = var.private_data_subnet_az2_cidr

}

//create nat gateway

module "NAT_gateway" {
  source = "../modules/NAT_gateway"
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  internet_gateway = module.vpc.internet_gateway
  public_subnet_az2_id = module.vpc.public_subnet_az2_id 
  vpc_id = module.vpc.vpc_id
  private_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_subnet_az2_id = module.vpc.private_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

//xreate the security groups
module "security_group" {
  source = "../modules/Security_Groups"
  vpc_id = module.vpc.vpc_id 
  }

  //create the ECS task execution role
  module "ecs_task_execution_role" {
    source = "../modules/ECS-task-execution-role"
    project_name = module.vpc.project_name
    
  }

