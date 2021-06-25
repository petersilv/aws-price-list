# ----------------------------------------------------------------------------------------------------------------------
# Locals

locals {

  snowflake_application = upper(var.application_one_word)
  snowflake_table       = upper(var.table_name)

}

# ----------------------------------------------------------------------------------------------------------------------
# Variables

variable "application" {
  type = string
}

variable "application_one_word" {
  type = string
}

variable "table_name" {
  type = string
}

variable "stage_folder" {
  type = string
}

variable "snowflake_warehouse" {
  type = string
  default = "COMPUTE_WH"
}

variable "snowflake_database" {
  type = string
  default = "LANDING_DB"
}

variable "snowflake_schema" {
  type = string
  default = "PUBLIC"
}

variable "snowflake_stage" {
  type = string
}

variable "aws_s3_bucket_id" {
  type = string
}
