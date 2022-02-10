locals {
  sf_full_file_format_name = "${snowflake_file_format.enriched.database}.${snowflake_file_format.enriched.schema}.${snowflake_file_format.enriched.name}"
  folder_monitoring_enabled = var.folder_monitoring_stage_prefix != ""
}

resource "snowflake_storage_integration" "integration" {
  name                      = "${upper(local.prefix)}_SNOWFLAKE_STORAGE_INTEGRATION"
  type                      = "EXTERNAL_STAGE"
  enabled                   = true
  storage_allowed_locations = ["s3://${var.stage_bucket_name}/"]
  storage_provider          = "S3"
  storage_aws_role_arn      = local.snowflake_load_role_arn
}

resource "snowflake_database" "loader" {
  lifecycle {
    prevent_destroy = true
  }

  name = upper(var.sf_db_name)
}

resource "snowflake_schema" "atomic" {
  lifecycle {
    prevent_destroy = true
  }

  database = snowflake_database.loader.name
  name     = upper(var.sf_atomic_schema_name)
}

resource "snowflake_warehouse" "loader" {
  name           = upper(var.sf_wh_name)
  warehouse_size = var.sf_wh_size
  auto_suspend   = var.sf_wh_auto_suspend
  auto_resume    = var.sf_wh_auto_resume
}

resource "snowflake_file_format" "enriched" {
  name             = upper(var.sf_file_format_name)
  database         = snowflake_database.loader.name
  schema           = snowflake_schema.atomic.name
  format_type      = "JSON"
  compression      = "AUTO"
  binary_format    = "HEX"
  date_format      = "AUTO"
  time_format      = "AUTO"
  timestamp_format = "AUTO"
}

resource "snowflake_stage" "transformed" {
  name                = "${upper(local.prefix)}_TRANSFORMED_STAGE"
  url                 = "s3://${var.stage_bucket_name}/${trimsuffix(var.transformed_stage_prefix, "/")}/"
  database            = snowflake_database.loader.name
  schema              = snowflake_schema.atomic.name
  storage_integration = snowflake_storage_integration.integration.name
  file_format         = "FORMAT_NAME = ${local.sf_full_file_format_name}"
}

resource "snowflake_stage" "folder_monitoring" {
  count               = local.folder_monitoring_enabled ? 1 : 0
  name                = "${upper(local.prefix)}_FOLDER_MONITORING_STAGE"
  url                 = "s3://${var.stage_bucket_name}/${trimsuffix(var.folder_monitoring_stage_prefix, "/")}/"
  database            = snowflake_database.loader.name
  schema              = snowflake_schema.atomic.name
  storage_integration = snowflake_storage_integration.integration.name
  file_format         = "FORMAT_NAME = ${local.sf_full_file_format_name}"
}
