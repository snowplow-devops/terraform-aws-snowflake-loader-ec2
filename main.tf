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
  s3_stage_full_path = "s3://${var.stage_bucket_name}/${trimsuffix(var.stage_prefix, "/")}/"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "loader" {
  source = "./loader"

  count = var.loader_enabled ? 1 : 0

  name = var.name
  app_version = local.app_version
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  ssh_key_name = var.ssh_key_name
  ssh_ip_allowlist = var.ssh_ip_allowlist
  amazon_linux_2_ami_id = var.amazon_linux_2_ami_id
  tags = local.tags
  cloudwatch_logs_enabled = var.cloudwatch_logs_enabled
  cloudwatch_logs_retention_days = var.cloudwatch_logs_retention_days
  telemetry_script = join("", module.telemetry.*.amazon_linux_2_user_data)
  
  sqs_queue_name = var.sqs_queue_name

  default_iglu_resolvers = var.default_iglu_resolvers
  custom_iglu_resolvers = var.custom_iglu_resolvers
  iam_permissions_boundary = var.iam_permissions_boundary
}

module "telemetry" {
  source  = "snowplow-devops/telemetry/snowplow"
  version = "0.2.0"

  count = var.telemetry_enabled ? 1 : 0

  user_provided_id = var.user_provided_id
  cloud            = "AWS"
  region           = data.aws_region.current.name
  app_name         = local.app_name
  app_version      = local.app_version
  module_name      = local.module_name
  module_version   = local.module_version
}
