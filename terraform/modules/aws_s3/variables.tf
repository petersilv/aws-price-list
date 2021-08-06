# ----------------------------------------------------------------------------------------------------------------------
# Variables

variable "s3_bucket_unique_identifier" {
  type = string
}

variable "application_name" {
  type = string
}

variable "common_tags" {
  type = map
}

variable "snowflake_pipe_sqs" {
  type = string
}
