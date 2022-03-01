locals {
  snowflake_full_file_format_name = "${snowflake_file_format.enriched.database}.${snowflake_file_format.enriched.schema}.${snowflake_file_format.enriched.name}"
}

resource "snowflake_storage_integration" "integration" {
  name                      = "${upper(local.prefix)}_SNOWFLAKE_STORAGE_INTEGRATION"
  type                      = "EXTERNAL_STAGE"
  enabled                   = true
  storage_allowed_locations = ["s3://${var.stage_bucket_name}/"]
  storage_provider          = "S3"
  storage_aws_role_arn      = local.snowflake_iam_load_role_arn
}

resource "snowflake_database" "loader" {
  count = var.is_create_database ? 1 : 0

  lifecycle {
    prevent_destroy = true
  }

  name = local.db_name
}

resource "snowflake_schema" "atomic" {
  lifecycle {
    prevent_destroy = true
  }

  database = local.db_name
  name     = var.snowflake_schema
}

resource "snowflake_warehouse" "loader" {
  name           = local.wh_name
  warehouse_size = var.snowflake_wh_size
  auto_suspend   = var.snowflake_wh_auto_suspend
  auto_resume    = var.snowflake_wh_auto_resume
}

resource "snowflake_file_format" "enriched" {
  name             = upper(var.snowflake_file_format_name)
  database         = local.db_name
  schema           = snowflake_schema.atomic.name
  format_type      = "JSON"
  compression      = "AUTO"
  binary_format    = "HEX"
  date_format      = "AUTO"
  time_format      = "AUTO"
  timestamp_format = "YYYY-MM-DD HH24:MI:SS.FF"
}

resource "snowflake_stage" "transformed" {
  name                = local.transformed_stage_name
  url                 = local.transformed_stage_url
  database            = local.db_name
  schema              = snowflake_schema.atomic.name
  storage_integration = snowflake_storage_integration.integration.name
  file_format         = "FORMAT_NAME = ${local.snowflake_full_file_format_name}"
}

resource "snowflake_stage" "folder_monitoring" {
  count               = var.folder_monitoring_enabled ? 1 : 0
  name                = local.folder_monitoring_stage_name
  url                 = local.folder_monitoring_stage_url
  database            = local.db_name
  schema              = var.snowflake_schema
  storage_integration = snowflake_storage_integration.integration.name
  file_format         = "FORMAT_NAME = ${local.snowflake_full_file_format_name}"
}
