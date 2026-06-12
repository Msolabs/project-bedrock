terraform {
  backend "s3" {
    bucket = "bedrock-terraform-state-moshood"
    key    = "project-bedrock/terraform.tfstate"
    region = "us-east-1"
  }
}
