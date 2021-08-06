output "snowflake_json_table_name" {
  value = snowflake_table.json_table.name
}

output "snowflake_pipe_name" {
  value = snowflake_pipe.pipe.name
}

output "snowflake_pipe_sqs" {
  value = snowflake_pipe.pipe.notification_channel
}
