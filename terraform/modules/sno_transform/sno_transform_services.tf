# ----------------------------------------------------------------------------------------------------------------------
# Create Table

resource "snowflake_table" "table_services" {

  database = var.snowflake_database
  schema   = var.snowflake_schema
  name     = "${local.snowflake_application}_SERVICES"

  column {
    name = "SERVICES"
    type = "VARCHAR(16777216)"
  }

} 

# ----------------------------------------------------------------------------------------------------------------------
# Create Task

resource "snowflake_task" "task_services" {
  
  name = "TASK_SERVICES"
  
  warehouse = var.snowflake_warehouse
  database  = var.snowflake_database
  schema    = var.snowflake_schema
  
  sql_statement = templatefile(
    "../sql/transform_services.sql",
    {
      database:   var.snowflake_database
      schema:     var.snowflake_schema
      table:      snowflake_table.table_services.name
      json_table: "${local.snowflake_application}_JSON_DESCRIBESERVICES"
    }
  )
  
  enabled              = true
  schedule             = "USING CRON 0 22 * * SUN UTC"
  user_task_timeout_ms = 300000 

}