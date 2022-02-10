output "sf_loader_username" {
  value       = snowflake_user.loader.name
  description = "Snowflake username which is used by loader to perform loading"
}

output "sf_transformed_stage" {
  value       = snowflake_stage.transformed.name
  description = "Snowflake stage to load transformed events"
}

output "sf_folder_monitoring_stage" {
  value       = join("", snowflake_stage.folder_monitoring[*].name)
  description = "Snowflake stage for folder monitoring"
}

output "transformed_stage_path" {
  value       = snowflake_stage.transformed.url
  description = ""
}

output "folder_monitoring_stage_path" {
  value       = join("", snowflake_stage.folder_monitoring[*].url)
  description = ""
}
