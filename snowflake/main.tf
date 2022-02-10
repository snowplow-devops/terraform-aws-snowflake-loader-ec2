locals {
  module_name    = "snowplow-snowflake-resources"
  module_version = "0.1.0"

  account_id               = data.aws_caller_identity.current.account_id
  snowflake_load_role_arn  = "arn:aws:iam::${local.account_id}:role/${var.snowflake_iam_load_role_name}"

  # Some of the Snowflake resources are having problem when hypen is used in the name.
  prefix = replace(var.prefix, "-", "_")
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "iam" {
  source = "./iam"

  count = var.iam_role_enabled ? 1 : 0

  stage_bucket_name = var.stage_bucket_name
  snowflake_iam_load_role_name = var.snowflake_iam_load_role_name
  storage_aws_iam_user_arn = snowflake_storage_integration.integration.storage_aws_iam_user_arn
  storage_aws_external_id = snowflake_storage_integration.integration.storage_aws_external_id
  iam_permissions_boundary = var.iam_permissions_boundary
}
