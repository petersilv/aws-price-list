output "snowflake_user_arn" {
  value = snowflake_storage_integration.integration.storage_aws_iam_user_arn
}

output "snowflake_external_id" {
  value = snowflake_storage_integration.integration.storage_aws_external_id
}

output "snowflake_stage_name" {
  value = snowflake_stage.stage.name
}