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

output "snowflake_username" {
  value       = module.snowflake_resources.snowflake_username
  description = "Snowflake username which is used by loader to perform loading"
}

output "snowflake_password" {
  value       = module.snowflake_resources.snowflake_password
  description = "Snowflake password which is used by loader to perform loading"
}

output "snowflake_wh" {
  description = "Snowflake warehouse name"
  value       = module.snowflake_resources.snowflake_warehouse
}

output "snowflake_db" {
  description = "Snowflake db name"
  value       = module.snowflake_resources.snowflake_database
}

output "schema_name" {
  description = "Schema name"
  value       = module.snowflake_resources.snowflake_schema
}
