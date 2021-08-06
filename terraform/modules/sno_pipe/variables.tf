# ----------------------------------------------------------------------------------------------------------------------
# Locals

locals {

  database = upper(var.snowflake_database)
  schema   = upper(var.snowflake_schema)
  table    = upper(var.table_name)
  s3_prefix = join("", [var.stage_prefix, var.pipe_prefix])

}

# ----------------------------------------------------------------------------------------------------------------------
# Variables

variable "application_name" {
  type = string
}

variable "snowflake_database" {
  type = string
}

variable "snowflake_schema" {
  type = string
}

variable "snowflake_stage" {
  type = string
}

variable "stage_prefix" {
  type = string
}

variable "pipe_prefix" {
  type = string
}

variable "table_name" {
  type = string
}
