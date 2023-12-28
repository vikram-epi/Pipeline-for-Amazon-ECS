terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket         	   = "mycomponents-tfstate1"
    key              	   = "mycomponents-tfstate1/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
  }
}
provider "aws" {
  region  = "us-east-1"
}
