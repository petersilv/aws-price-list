# ----------------------------------------------------------------------------------------------------------------------
# Storage Integration

resource "snowflake_storage_integration" "integration" {

  name    = "S3_INT_${local.snowflake_application_name}"
  type    = "EXTERNAL_STAGE"
  enabled = true

  storage_provider          = "S3"
  storage_aws_role_arn      = "arn:aws:iam::${var.aws_account_id}:role/${var.application_name}-snowflake-role"
  storage_allowed_locations = ["s3://${var.aws_s3_bucket_id}/"]

}

# ----------------------------------------------------------------------------------------------------------------------
# Stage

resource "snowflake_stage" "stage" {
  
  name                = "S3_STAGE_${local.snowflake_application_name}"
  url                 = "s3://${var.aws_s3_bucket_id}/${var.stage_prefix}"
  database            = local.database
  schema              = local.schema
  storage_integration = snowflake_storage_integration.integration.name

}
