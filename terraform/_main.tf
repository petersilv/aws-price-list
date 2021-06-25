# ----------------------------------------------------------------------------------------------------------------------
terraform {

  required_version = ">= 0.15.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.44.0"
    }
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.4"
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

# ----------------------------------------------------------------------------------------------------------------------
module "aws_s3" {
  source = "./modules/aws_s3"

  application          = local.application
  application_one_word = local.application_one_word
  common_tags          = local.common_tags

}

# ----------------------------------------------------------------------------------------------------------------------
module "aws_lambda" {
  source = "./modules/aws_lambda"

  application          = local.application
  application_one_word = local.application_one_word
  common_tags          = local.common_tags

  aws_s3_bucket_id  = module.aws_s3.aws_s3_bucket_id
  aws_s3_bucket_arn = module.aws_s3.aws_s3_bucket_arn

}

# ----------------------------------------------------------------------------------------------------------------------
module "sno_integration" {
  source = "./modules/sno_integration"

  application          = local.application
  application_one_word = local.application_one_word
  common_tags          = local.common_tags

  snowflake_database = local.snowflake_database
  snowflake_schema   = local.snowflake_schema

  aws_account_id    = local.aws_account_id
  aws_s3_bucket_id  = module.aws_s3.aws_s3_bucket_id
  aws_s3_bucket_arn = module.aws_s3.aws_s3_bucket_arn

}

# ----------------------------------------------------------------------------------------------------------------------
module "sno_pipe_describeservices" {
  source = "./modules/sno_pipe"

  application          = local.application
  application_one_word = local.application_one_word

  snowflake_database    = local.snowflake_database
  snowflake_schema      = local.snowflake_schema
  snowflake_stage       = module.sno_integration.snowflake_stage

  stage_folder = "describeservices"
  table_name   = "DESCRIBESERVICES"

  aws_s3_bucket_id = module.aws_s3.aws_s3_bucket_id

}

# ----------------------------------------------------------------------------------------------------------------------
module "sno_pipe_getattributevalues" {
  source = "./modules/sno_pipe"

  application          = local.application
  application_one_word = local.application_one_word

  snowflake_database    = local.snowflake_database
  snowflake_schema      = local.snowflake_schema
  snowflake_stage       = module.sno_integration.snowflake_stage

  stage_folder = "getattributevalues"
  table_name   = "GETATTRIBUTEVALUES"

  aws_s3_bucket_id = module.aws_s3.aws_s3_bucket_id

}
