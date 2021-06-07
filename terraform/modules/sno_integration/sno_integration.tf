# ----------------------------------------------------------------------------------------------------------------------
# Storage Integration

resource "snowflake_storage_integration" "integration" {

  name    = "S3_INT_${local.snowflake_application}"
  type    = "EXTERNAL_STAGE"
  enabled = true

  storage_provider          = "S3"
  storage_aws_role_arn      = "arn:aws:iam::${var.aws_account_id}:role/${var.application_short}-role"
  storage_allowed_locations = ["s3://${var.aws_s3_bucket_id}/"]

}

# ----------------------------------------------------------------------------------------------------------------------
# Stage

resource "snowflake_stage" "stage" {
  
  name                = "S3_STAGE_${local.snowflake_application}"
  url                 = "s3://${var.aws_s3_bucket_id}/data"
  database            = var.snowflake_database
  schema              = var.snowflake_schema
  storage_integration = snowflake_storage_integration.integration.name

}

