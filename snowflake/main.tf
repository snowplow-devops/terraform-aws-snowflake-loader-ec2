locals {
  module_name    = "snowplow-snowflake-resources"
  module_version = "0.1.0"

  snowflake_iam_load_role_name = "${var.name}-snowflakedb-load-role"
  snowflake_iam_load_role_arn  = "arn:aws:iam::${var.account_id}:role/${local.snowflake_iam_load_role_name}"
  prefix                       = replace(var.name, "-", "_")
}
