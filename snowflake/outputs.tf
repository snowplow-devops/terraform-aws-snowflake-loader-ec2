# --- Users

output "snowflake_loader_user" {
  description = "Snowflake username which is used by loader to perform loading"
  value       = local.snowflake_loader_user
}

output "snowflake_password" {
  value       = var.snowflake_loader_password
  sensitive   = true
  description = "Snowflake password which is used by loader to perform loading"
}

output "snowflake_loader_role" {
  description = "Snowflake loader user role"
  value       = local.snowflake_loader_role
}

# --- Storage

output "snowflake_warehouse" {
  description = "Snowflake warehouse name"
  value       = local.wh_name
}

output "snowflake_database" {
  description = "Snowflake database name"
  value       = local.db_name
}

output "snowflake_schema" {
  description = "Schema name"
  value       = var.snowflake_schema
}

output "snowflake_transformed_stage_name" {
  description = "Name of transformed stage"
  value       = local.transformed_stage_name
}

output "snowflake_monitoring_stage_name" {
  description = "Name of monitoring stage"
  value       = local.folder_monitoring_stage_name
}

# --- AWS counterparts

output "transformed_stage_path" {
  description = "Url of transformed stage"
  value       = snowflake_stage.transformed.url
}

output "folder_monitoring_stage_path" {
  description = "Url of folder monitoring stage"
  value       = join("", snowflake_stage.folder_monitoring[*].url)
}

output "storage_aws_external_id" {
  description = "AWS external id"
  value       = snowflake_storage_integration.integration.storage_aws_external_id
}

output "iam_load_role_arn" {
  description = "AWS IAM role ARN which will be used to load the data"
  value       = local.snowflake_iam_load_role_arn
}

output "iam_load_role_name" {
  description = "AWS IAM role name which will be used to load the data"
  value       = local.snowflake_iam_load_role_name
}


output "transformed_stage_url" {
  description = "Url of transformed stage"
  value       = local.transformed_stage_url
}

output "monitoring_stage_url" {
  description = "Url of monitoring stage"
  value       = local.folder_monitoring_stage_url
}


