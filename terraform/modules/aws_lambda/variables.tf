# ----------------------------------------------------------------------------------------------------------------------
# Locals

locals {
}

# ----------------------------------------------------------------------------------------------------------------------
# Variables

variable "application" {
  type = string
}

variable "application_short" {
  type = string
}

variable "common_tags" {
  type = map
}

variable "aws_s3_bucket_id" {
  type = string
}

variable "aws_s3_bucket_arn" {
  type = string
}