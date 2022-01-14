locals {
  module_name    = "snowflake-loader"
  module_version = "0.1.0"

  app_name    = "snowplow-snowflake-loader"
  app_version = "2.0.0"

  local_tags = {
    Name           = var.name
    app_name       = local.app_name
    app_version    = local.app_version
    module_name    = local.module_name
    module_version = local.module_version
  }

  tags = merge(
    var.tags,
    local.local_tags
  )

  account_id  = data.aws_caller_identity.current.account_id
  snowflake_load_role_name = "${var.name}-snowflakedb-load"
  snowflake_load_role_arn = "arn:aws:iam::${local.account_id}:role/${local.snowflake_load_role_name}"
  s3_stage_full_path = "s3://${var.stage_bucket_name}/${var.stage_prefix}/"
}
