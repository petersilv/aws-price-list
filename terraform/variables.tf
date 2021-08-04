# ----------------------------------------------------------------------------------------------------------------------
# General

variable "application_name" {
  type        = string
  description = "The name of the application / project to be deployed. This value will be used in the naming of most of the created resources. Value should be lowercase alphanumeric characters only with no spaces."
}

# ----------------------------------------------------------------------------------------------------------------------
# AWS

variable "aws_profile" {
  type        = string
  description = "The name of the AWS profile name as set in the shared credentials file."
}

variable "aws_region" {
  type        = string
  description = "The region in which the AWS resources will be deployed."
}

variable "s3_bucket_unique_identifier" {
  type        = string
  description = "The S3 bucket will be named with the pattern \"{unique_identifier}-{application_name}\", this is necessary as S3 buckets must be globally unqiue."
}

# ----------------------------------------------------------------------------------------------------------------------
# Snowflake

variable "snowflake_role" {
  type        = string
  description = "The name of the role that will deploy the Pipe, the role must have privileges on the chosen database and have been granted the account level \"CREATE INTEGRATION\" privilege."
}

variable "snowflake_database" {
  type        = string
  description = "The name of the database that the Pipe will be added to (must already exist)."
}

variable "snowflake_schema" {
  type        = string
  description = "The name of the schema that the Pipe will be added to (must already exist)."
}

variable "stage_prefix" {
  type        = string
  description = "The S3 prefix that the Snowflake Stage will get access to (eg. if the you are giving access to the \"public\" folder inside the \"data\" folder in the \"example\" bucket the value would be \"data/public/\"). This can be left blank."
}

variable "pipe_prefix" {
  type        = string
  description = "The S3 prefix that the Pipe will get access to, starting from the stage folder (eg. if the stage has access to the \"data/public/\" prefix and the Pipe should have access to \"data/public/new/\" the value would be \"new/\" ). This can be left blank which would give the same access as the Stage."
}

variable "table_name" {
  type        = string
  description = "The name of the table that the Pipe will write to"
}

# ----------------------------------------------------------------------------------------------------------------------
# Locals

data "aws_caller_identity" "current" {}

locals {

  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_caller_arn  = data.aws_caller_identity.current.arn
  aws_caller_user = data.aws_caller_identity.current.user_id

  common_tags = {
    application_name = var.application_name
    owner_arn        = local.aws_caller_arn
    created_with     = "Terraform"
  }

}
