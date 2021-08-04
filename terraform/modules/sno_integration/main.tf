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
      version = ">= 0.25.4"
    }
  }

}
