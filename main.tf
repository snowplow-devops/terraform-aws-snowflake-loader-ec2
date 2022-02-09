locals {
  module_name    = "snowflake-loader"
  module_version = "0.1.0"

  app_name    = "snowplow-snowflake-loader"
  app_version = "3.0.0-rc4"

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

  account_id               = data.aws_caller_identity.current.account_id
  snowflake_load_role_name = "${var.name}-snowflakedb-load"
  snowflake_load_role_arn  = "arn:aws:iam::${local.account_id}:role/${local.snowflake_load_role_name}"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "loader" {
  source = "./loader"

  count = var.loader_enabled ? 1 : 0

  name                           = var.name
  app_version                    = local.app_version
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  instance_type                  = var.instance_type
  associate_public_ip_address    = var.associate_public_ip_address
  ssh_key_name                   = var.ssh_key_name
  ssh_ip_allowlist               = var.ssh_ip_allowlist
  amazon_linux_2_ami_id          = var.amazon_linux_2_ami_id
  tags                           = local.tags
  cloudwatch_logs_enabled        = var.cloudwatch_logs_enabled
  cloudwatch_logs_retention_days = var.cloudwatch_logs_retention_days
  telemetry_script               = join("", module.telemetry.*.amazon_linux_2_user_data)

  sqs_queue_name             = var.sqs_queue_name
  sf_region                  = var.sf_region
  sf_username                = snowflake_user.loader.name
  sf_password                = var.sf_loader_password
  sf_account                 = var.sf_account
  sf_wh_name                 = snowflake_warehouse.loader.name
  sf_db_name                 = snowflake_database.loader.name
  sf_transformed_stage       = snowflake_stage.transformed.name
  folder_monitoring_enabled  = var.folder_monitoring_enabled
  sf_folder_monitoring_stage = join("", snowflake_stage.folder_monitoring[*].name)
  sf_schema                  = snowflake_schema.atomic.name
  sf_max_error               = var.sf_max_error
  sp_tracking_enabled        = var.sp_tracking_enabled
  sp_tracking_app_id         = var.sp_tracking_app_id
  sp_tracking_collector_url  = var.sp_tracking_collector_url
  sentry_enabled             = var.sentry_enabled
  sentry_dsn                 = var.sentry_dsn
  statsd_enabled             = var.statsd_enabled
  statsd_host                = var.statsd_host
  statsd_port                = var.statsd_port
  stdout_metrics_enabled     = var.stdout_metrics_enabled
  webhook_enabled            = var.webhook_enabled
  webhook_collector          = var.webhook_collector
  folder_monitoring_staging  = var.folder_monitoring_staging
  folder_monitoring_period   = var.folder_monitoring_period
  folder_monitoring_since    = var.folder_monitoring_since
  folder_monitoring_until    = var.folder_monitoring_until
  shredder_output            = var.shredder_output
  health_check_enabled       = var.health_check_enabled
  health_check_freq          = var.health_check_freq
  health_check_timeout       = var.health_check_timeout
  retry_queue_enabled        = var.retry_queue_enabled
  retry_period               = var.retry_period
  retry_queue_size           = var.retry_queue_size
  retry_queue_max_attempt    = var.retry_queue_max_attempt
  retry_queue_interval       = var.retry_queue_interval

  default_iglu_resolvers   = var.default_iglu_resolvers
  custom_iglu_resolvers    = var.custom_iglu_resolvers
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
