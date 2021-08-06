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
  profile = var.aws_profile
  region  = var.aws_region
}

provider "snowflake" {
  role = var.snowflake_role
}

# ----------------------------------------------------------------------------------------------------------------------
module "aws_s3" {
  source = "./modules/aws_s3"

  s3_bucket_unique_identifier = var.s3_bucket_unique_identifier
  application_name            = var.application_name
  common_tags                 = local.common_tags

  snowflake_pipe_sqs    = module.sno_pipe_describeservices.snowflake_pipe_sqs

}

# ----------------------------------------------------------------------------------------------------------------------
module "aws_lambda" {
  source = "./modules/aws_lambda"

  application_name = var.application_name
  common_tags      = local.common_tags

  aws_s3_bucket_id  = module.aws_s3.aws_s3_bucket_id
  aws_s3_bucket_arn = module.aws_s3.aws_s3_bucket_arn

}

# ----------------------------------------------------------------------------------------------------------------------
module "sno_integration" {
  source = "./modules/sno_integration"

  application_name = var.application_name
  common_tags      = local.common_tags

  snowflake_database = var.snowflake_database
  snowflake_schema   = var.snowflake_schema
  stage_prefix       = var.stage_prefix

  aws_account_id    = local.aws_account_id
  aws_s3_bucket_id  = module.aws_s3.aws_s3_bucket_id
  aws_s3_bucket_arn = module.aws_s3.aws_s3_bucket_arn

}

# ----------------------------------------------------------------------------------------------------------------------
module "sno_pipe_describeservices" {
  source = "./modules/sno_pipe"

  application_name = var.application_name

  snowflake_database = var.snowflake_database
  snowflake_schema   = var.snowflake_schema
  snowflake_stage    = module.sno_integration.snowflake_stage
  stage_prefix       = var.stage_prefix
  pipe_prefix        = var.pipe_prefix_1
  table_name         = var.table_name_1

}

# ----------------------------------------------------------------------------------------------------------------------
module "sno_pipe_getattributevalues" {
  source = "./modules/sno_pipe"

  application_name = var.application_name

  snowflake_database = var.snowflake_database
  snowflake_schema   = var.snowflake_schema
  snowflake_stage    = module.sno_integration.snowflake_stage
  stage_prefix       = var.stage_prefix
  pipe_prefix        = var.pipe_prefix_2
  table_name         = var.table_name_2

}

# ----------------------------------------------------------------------------------------------------------------------
module "sno_pipe_getproducts" {
  source = "./modules/sno_pipe"

  application_name = var.application_name

  snowflake_database = var.snowflake_database
  snowflake_schema   = var.snowflake_schema
  snowflake_stage    = module.sno_integration.snowflake_stage
  stage_prefix       = var.stage_prefix
  pipe_prefix        = var.pipe_prefix_3
  table_name         = var.table_name_3
  
}
