terraform {
  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
}

# provider "akeyless" {
#   api_gateway_address = "https://api.akeyless.io"
#   jwt_login {
#     access_id = var.AKEYLESS_ACCESS_ID
#   }
  
# }

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Make a aws mysql instance
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}