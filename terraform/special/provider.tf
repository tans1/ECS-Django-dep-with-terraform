# this is to create S3 bucket to store the state , we can do it in the console as well
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
}


############################################################################
# S3
###########################################################################
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "tf-state-bucket-tof-ecs-2024"
}
resource "aws_s3_bucket_ownership_controls" "terraform_state_ocontrols" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "terraform_state_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.terraform_state_ocontrols]

  bucket = aws_s3_bucket.terraform_state_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

##############################################################################
# DynamoDb
#############################################################################
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tf-locks-tof-ecs-2024"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  depends_on = [ aws_s3_bucket.terraform_state_bucket ]
}
