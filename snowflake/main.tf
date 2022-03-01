locals {
  module_name    = "snowplow-snowflake-resources"
  module_version = "0.1.0"

  snowflake_loader_user        = var.override_snowflake_loader_user == "" ?  var.override_snowflake_loader_user : "${upper(local.prefix)}_LOADER_USER"
  snowflake_loader_role        = var.override_snowflake_loader_role == "" ?  var.override_snowflake_loader_role : "${upper(local.prefix)}_LOADER_ROLE"
  wh_name                      = var.override_snowflake_wh_name == "" ?  var.override_snowflake_wh_name : "${upper(local.prefix)}_WAREHOUSE"
  db_name                      = var.override_snowflake_db_name == "" ?  var.override_snowflake_db_name : "${upper(local.prefix)}_DATABASE"
  transformed_stage_name       = "${upper(local.prefix)}_TRANSFORMED_STAGE"
  transformed_stage_url        = var.override_transformed_stage_url == "" ?  var.override_transformed_stage_url : "s3://${var.stage_bucket_name}/${var.name}/shredded/v1"
  folder_monitoring_stage_name = "${upper(local.prefix)}_FOLDER_MONITORING_STAGE"
  folder_monitoring_stage_url  = var.override_folder_monitoring_stage_url == "" ?  var.override_folder_monitoring_stage_url : "s3://${var.stage_bucket_name}/${var.name}/monitoring"
  snowflake_iam_load_role_name = var.override_iam_loader_role_name == "" ?  var.override_iam_loader_role_name : "${local.prefix}-snowflakedb-load-role"
  snowflake_iam_load_role_arn  = "arn:aws:iam::${var.account_id}:role/${local.snowflake_iam_load_role_name}"
  prefix                       = replace(var.name, "-", "_")
}
