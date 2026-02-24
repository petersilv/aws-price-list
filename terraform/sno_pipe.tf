# ----------------------------------------------------------------------------------------------------------------------
# Wait for IAM policy attachment

resource "time_sleep" "policy_attach" {
  create_duration = "30s"
  triggers        = { stage = snowflake_stage_external_s3.stage.name }
}

# ----------------------------------------------------------------------------------------------------------------------
# Pipe

resource "snowflake_pipe" "pipe" {

  database    = local.sno_database
  schema      = snowflake_schema.schema.name
  name        = "PIPE_${local.sno_table}"
  auto_ingest = true

  copy_statement = templatefile(
    "./sno_pipe.sql",
    {
      database : local.sno_database
      schema : snowflake_schema.schema.name
      table : snowflake_table.json_table.name
      stage : time_sleep.policy_attach.triggers["stage"]
      pipe_prefix : var.pipe_prefix
    }
  )

}
