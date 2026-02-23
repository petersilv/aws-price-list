# ----------------------------------------------------------------------------------------------------------------------
# Schema

resource "snowflake_schema" "schema" {
  name     = local.sno_schema
  database = local.sno_database
}

# ----------------------------------------------------------------------------------------------------------------------
# Landing Table

resource "snowflake_table" "json_table" {

  database = local.sno_database
  schema   = snowflake_schema.schema.name
  name     = local.sno_table

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
