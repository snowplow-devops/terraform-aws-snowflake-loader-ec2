locals {
  sf_full_file_format_name = "${snowflake_file_format.enriched.database}.${snowflake_file_format.enriched.schema}.${snowflake_file_format.enriched.name}"
}

resource "snowflake_storage_integration" "integration" {
  name    = "${upper(var.name)}_SNOWFLAKE_STORAGE_INTEGRATION"
  type    = "EXTERNAL_STAGE"
  enabled = true
  storage_allowed_locations = [local.s3_stage_full_path]
  storage_provider         = "S3"
  storage_aws_role_arn     = local.snowflake_load_role_arn
}

resource "snowflake_database" "loader" {
  name  = var.sf_db_name
}

resource "snowflake_schema" "atomic" {
  database = snowflake_database.loader.name
  name     = var.sf_atomic_schema_name
}

resource "snowflake_warehouse" "loader" {
  name           = var.sf_wh_name
  warehouse_size = var.sf_wh_size
  auto_suspend   = var.sf_wh_auto_suspend
  auto_resume    = var.sf_wh_auto_resume
}

resource "snowflake_file_format" "enriched" {
  name        = var.sf_file_format_name
  database    = snowflake_database.loader.name
  schema      = snowflake_schema.atomic.name
  format_type = "JSON"
  compression = "AUTO"
  binary_format = "HEX"
  date_format = "AUTO"
  time_format = "AUTO"
  timestamp_format = "YYYY-MM-DD HH24:MI:SS.FF"
}

resource "snowflake_stage" "loader" {
  name        = var.sf_stage_name
  url         = local.s3_stage_full_path
  database    = snowflake_database.loader.name
  schema      = snowflake_schema.atomic.name
  storage_integration = snowflake_storage_integration.integration.name
  file_format = "FORMAT_NAME = ${local.sf_full_file_format_name}"
}
