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

variable "aws_s3_bucket_id" {
  type = string
}

# ----------------------------------------------------------------------------------------------------------------------
# AWS Local Vars

data "aws_caller_identity" "current" {}

locals {

  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_caller_arn  = data.aws_caller_identity.current.arn
  aws_caller_user = data.aws_caller_identity.current.user_id

  aws_s3_bucket_arn = "arn:aws:s3:::${var.aws_s3_bucket_id}"

  common_tags = {
    application_name = var.application_name
    owner_arn        = local.aws_caller_arn
    created_with     = "Terraform"
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Snowflake Credentials

variable "sno_user" {
  type = string
}

variable "sno_organization_name" {
  type = string
}

variable "sno_account_name" {
  type = string
}

variable "sno_role" {
  type        = string
  description = "The name of the role that will deploy the Pipe, the role must have privileges on the chosen database and have been granted the account level \"CREATE INTEGRATION\" privilege."
}

variable "sno_private_key_path" {
  type = string
}

variable "sno_private_key_passphrase" {
  type = string
}

# ----------------------------------------------------------------------------------------------------------------------
# Snowflake Objects

variable "sno_database" {
  type        = string
  description = "The name of the database that the Pipe will be added to (must already exist)."
}

variable "sno_schema" {
  type        = string
  description = "The name of the schema that the Pipe will be added to (must already exist)."
}

variable "sno_table" {
  type        = string
  description = "The name of the table that the Pipe will write to"
}

variable "stage_prefix" {
  type        = string
  description = "The S3 prefix that the Snowflake Stage will get access to (eg. if the you are giving access to the \"public\" folder inside the \"data\" folder in the \"example\" bucket the value would be \"data/public/\"). This can be left blank."
}

variable "pipe_prefix" {
  type        = string
  description = "The S3 prefix that the Pipe will get access to, starting from the stage folder (eg. if the stage has access to the \"data/public/\" prefix and the Pipe should have access to \"data/public/new/\" the value would be \"new/\" ). This can be left blank which would give the same access as the Stage."
}

# ----------------------------------------------------------------------------------------------------------------------
# Snowflake Local Vars

locals {

  sno_user              = upper(var.sno_user)
  sno_organization_name = upper(var.sno_organization_name)
  sno_account_name      = upper(var.sno_account_name)
  sno_role              = upper(var.sno_role)

  sno_application_name = replace(upper(var.application_name), "-", "_")
  sno_database         = upper(var.sno_database)
  sno_schema           = upper(var.sno_schema)
  sno_table            = upper(var.sno_table)

}
