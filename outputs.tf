output "asg_id" {
  value       = join("", module.loader[*].asg_id)
  description = "ID of the ASG"
}

output "asg_name" {
  value       = join("", module.loader[*].asg_name)
  description = "Name of the ASG"
}

output "sg_id" {
  value       = join("", module.loader[*].sg_id)
  description = "ID of the security group attached to the Snowflake Loader servers"
}

output "sf_username" {
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
