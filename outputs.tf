output "asg_id" {
  value       = aws_autoscaling_group.asg.id
  description = "ID of the ASG"
}

output "asg_name" {
  value       = aws_autoscaling_group.asg.name
  description = "Name of the ASG"
}

output "sg_id" {
  value       = aws_security_group.sg.id
  description = "ID of the security group attached to the Snowflake Loader servers"
}

output "sf_username" {
  value       = module.snowflake_resources.sf_loader_username
  description = "Snowflake username which is used by loader to perform loading"
}

output "sf_transformed_stage" {
  value       = module.snowflake_resources.sf_transformed_stage
  description = "Snowflake stage to load transformed events"
}

output "sf_folder_monitoring_stage" {
  value       = module.snowflake_resources.sf_folder_monitoring_stage
  description = "Snowflake stage for folder monitoring"
}
