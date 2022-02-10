resource "snowflake_role" "loader" {
  name = "${upper(local.prefix)}_LOADER_ROLE"
}

resource "snowflake_warehouse_grant" "loader" {
  for_each          = toset(["MODIFY", "MONITOR", "USAGE", "OPERATE"])
  warehouse_name    = snowflake_warehouse.loader.name
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_database_grant" "loader" {
  database_name     = snowflake_database.loader.name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_file_format_grant" "loader" {
  database_name     = snowflake_database.loader.name
  schema_name       = snowflake_schema.atomic.name
  file_format_name  = snowflake_file_format.enriched.name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_integration_grant" "loader" {
  integration_name  = snowflake_storage_integration.integration.name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_stage_grant" "transformed" {
  database_name     = snowflake_database.loader.name
  schema_name       = snowflake_schema.atomic.name
  stage_name        = snowflake_stage.transformed.name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_stage_grant" "folder_monitoring" {
  for_each          = toset(snowflake_stage.folder_monitoring[*].name)
  database_name     = snowflake_database.loader.name
  schema_name       = snowflake_schema.atomic.name
  stage_name        = each.value
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_schema_grant" "loader" {
  for_each = toset([
    "CREATE EXTERNAL TABLE",
    "CREATE FILE FORMAT",
    "CREATE FUNCTION",
    "CREATE MASKING POLICY",
    "CREATE PIPE",
    "CREATE PROCEDURE",
    "CREATE SEQUENCE",
    "CREATE STAGE",
    "CREATE STREAM",
    "CREATE TABLE",
    "CREATE TASK",
    "CREATE TEMPORARY TABLE",
    "CREATE VIEW",
    "MODIFY",
    "MONITOR",
    "USAGE"
  ])
  database_name     = snowflake_database.loader.name
  schema_name       = snowflake_schema.atomic.name
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_table_grant" "loader" {
  for_each = toset([
    "DELETE",
    "INSERT",
    "OWNERSHIP",
    "REFERENCES",
    "SELECT",
    "TRUNCATE",
    "UPDATE"
  ])
  database_name     = snowflake_database.loader.name
  schema_name       = snowflake_schema.atomic.name
  table_name        = snowflake_table.events.name
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_user" "loader" {
  name                 = "${upper(local.prefix)}_LOADER_USER"
  password             = var.sf_loader_password
  default_role         = snowflake_role.loader.name
  must_change_password = false
}

resource "snowflake_role_grants" "loader" {
  role_name = snowflake_role.loader.name
  users     = [snowflake_user.loader.name]
}
