# ----------------------------------------------------------------------------------------------------------------------
# Locals

locals {

  snowflake_application_name = upper(var.application_name)
  database                   = upper(var.snowflake_database)
  schema                     = upper(var.snowflake_schema)

}

# ----------------------------------------------------------------------------------------------------------------------
# Variables

variable "application_name" {
  type = string
}

variable "common_tags" {
  type = map
}

variable "snowflake_database" {
  type = string
}

variable "snowflake_schema" {
  type = string
}

variable "stage_prefix" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "aws_s3_bucket_id" {
  type = string
}

variable "aws_s3_bucket_arn" {
  type = string
}
