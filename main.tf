locals {
  account_id  = data.aws_caller_identity.current.account_id
  snowflake_load_role_name = "${var.name}-snowflakedb-load"
  snowflake_load_role_arn = "arn:aws:iam::${local.account_id}:role/${local.snowflake_load_role_name}"
  s3_stage_full_path = "s3://${var.stage_bucket_name}/${var.stage_prefix}/"
}
