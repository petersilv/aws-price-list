# ----------------------------------------------------------------------------------------------------------------------
# Locals

locals {

  snowflake_application = upper(var.application_one_word)

}

# ----------------------------------------------------------------------------------------------------------------------
# Variables

variable "application" {
  type = string
}

variable "application_one_word" {
  type = string
}

variable "snowflake_warehouse" {
  type = string
}

variable "snowflake_database" {
  type = string
}

variable "snowflake_schema" {
  type = string
}
