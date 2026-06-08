module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "project-bedrock-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # Standard criteria compliance
  enable_nat_gateway = true
  single_nat_gateway = true # Keeps costs to a minimum

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "Project"                = "karatu-2025-capstone"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "Project"                         = "karatu-2025-capstone"
  }
}