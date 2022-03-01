output "snowflake_username" {
  value       = snowflake_user.loader.name
  description = "Snowflake username which is used by loader to perform loading"
}

output "snowflake_password" {
  value       = var.snowflake_loader_password
  sensitive   = true
  description = "Snowflake password which is used by loader to perform loading"
}

output "snowflake_warehouse" {
  description = "Snowflake warehouse name"
  value       = local.wh_name
}

output "snowflake_database" {
  description = "Snowflake db name"
  value       = local.db_name
}

output "transformed_stage_name" {
  description = "Name of transformed stage"
  value       = local.transformed_stage_name
}

output "monitoring_stage_name" {
  description = "Name of monitoring stage"
  value       = local.folder_monitoring_stage_name
}

output "snowflake_schema" {
  description = "Schema name"
  value       = local.schema_name
}

output "transformed_stage_path" {
  value       = snowflake_stage.transformed.url
  description = ""
}

output "folder_monitoring_stage_path" {
  value       = join("", snowflake_stage.folder_monitoring[*].url)
  description = ""
}

output "storage_aws_external_id" {
  value = snowflake_storage_integration.integration.storage_aws_external_id
}

output "snowflake_iam_load_role_arn" {
  value = local.snowflake_iam_load_role_arn
}

output "snowflake_iam_load_role_name" {
  value = local.snowflake_iam_load_role_name
}

