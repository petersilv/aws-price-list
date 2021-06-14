# ----------------------------------------------------------------------------------------------------------------------
# Create Table

resource "snowflake_table" "json_table" {

  database = var.snowflake_database
  schema   = var.snowflake_schema
  name     = "${local.snowflake_application}_JSON_${upper(var.table_name)}"

  column {
    name = "RECORDS"
    type = "VARIANT"
  }

  column {
    name = "FULL_PATH"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "DIRECTORY"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "FILE_NAME"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "UPDATED_AT"
    type = "TIMESTAMP_TZ(9)"
  }

} 

# ----------------------------------------------------------------------------------------------------------------------
# Wait for IAM policy attachment

resource "time_sleep" "policy_attach" {
  create_duration = "30s"
  triggers = {stage = var.snowflake_stage}
}

# ----------------------------------------------------------------------------------------------------------------------
# Create Pipe

resource "snowflake_pipe" "pipe" {

  database    = var.snowflake_database
  schema      = var.snowflake_schema
  name        = "PIPE_${upper(var.table_name)}"
  auto_ingest = true

  copy_statement = templatefile(
    var.sql_filepath,
    {
      database: var.snowflake_database
      schema:   var.snowflake_schema
      table:    snowflake_table.json_table.name,
      stage:    time_sleep.policy_attach.triggers["stage"]
    }
  )

}

# ----------------------------------------------------------------------------------------------------------------------
# S3 Notification

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = var.aws_s3_bucket_id

  queue {
    queue_arn = snowflake_pipe.pipe.notification_channel
    events    = ["s3:ObjectCreated:*"]
  }

}
