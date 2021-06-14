# ----------------------------------------------------------------------------------------------------------------------
terraform {

  required_version = ">= 0.15.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.38"
    }
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.0"
    }
  }

}

provider "aws" {
  profile = "terraform"
  region  = "eu-west-2"
}

provider "snowflake" {
  role = "SYSADMIN"
}