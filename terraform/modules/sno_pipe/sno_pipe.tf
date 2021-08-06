# ----------------------------------------------------------------------------------------------------------------------
# Create Table

resource "snowflake_table" "json_table" {

  database = local.database
  schema   = local.schema
  name     = local.table

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

  database    = local.database
  schema      = local.schema
  name        = "PIPE_${local.table}"
  auto_ingest = true

  copy_statement = templatefile(
    "./sql/pipe.sql",
    {
      database:    local.database
      schema:      local.schema
      table:       snowflake_table.json_table.name
      stage:       time_sleep.policy_attach.triggers["stage"]
      pipe_prefix: var.pipe_prefix
    }
  )

}
