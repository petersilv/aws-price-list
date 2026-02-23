# ----------------------------------------------------------------------------------------------------------------------
# Storage Integration

resource "snowflake_storage_integration_aws" "integration" {

  name    = "S3_INT_${local.sno_application_name}"
  enabled = true

  storage_provider          = "S3"
  storage_aws_role_arn      = "arn:aws:iam::${local.aws_account_id}:role/${var.application_name}-snowflake-role"
  storage_allowed_locations = ["s3://${var.aws_s3_bucket_id}/"]

}

# ----------------------------------------------------------------------------------------------------------------------
# Stage

resource "snowflake_stage_external_s3" "stage" {

  name                = "S3_STAGE_${local.sno_application_name}"
  url                 = "s3://${var.aws_s3_bucket_id}/${var.stage_prefix}"
  database            = local.sno_database
  schema              = snowflake_schema.schema.name
  storage_integration = snowflake_storage_integration_aws.integration.name

}

