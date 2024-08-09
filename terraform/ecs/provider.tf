provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  backend "s3" {
    bucket         = "tf-state-bucket-tof-ecs-2024"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "tf-locks-tof-ecs-2024"
    encrypt        = true
    profile        = "tf-2"
  }
}
