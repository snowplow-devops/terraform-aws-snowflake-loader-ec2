locals {
  module_name    = "snowflake-loader"
  module_version = "0.1.0"

  app_name    = "snowplow-snowflake-loader"
  app_version = "3.0.0-rc12"

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

  account_id                     = data.aws_caller_identity.current.account_id
  snowflake_iam_load_policy_name = "${var.name}-snowflakedb-load-pol"
  cloudwatch_log_group_name      = "/aws/ec2/${var.name}-snowflake-loader"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# --- CloudWatch: Logging

resource "aws_cloudwatch_log_group" "log_group" {
  count = var.cloudwatch_logs_enabled ? 1 : 0

  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention_days

  tags = local.tags
}

# --- IAM: Roles & Permissions

resource "aws_iam_role" "iam_role_loader" {
  name        = "${var.name}-snowflake-loader"
  description = "Allows the Loader nodes to access required services"
  tags        = local.tags

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": [ "ec2.amazonaws.com" ]},
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF

  permissions_boundary = var.iam_permissions_boundary
}

resource "aws_iam_policy" "iam_policy_loader" {
  name = "${var.name}-snowflake-loader"
  tags = local.tags

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      var.folder_monitoring_enabled ? [
        {
          Effect = "Allow",
          Action = [
            "s3:ListBucket",
            "s3:PutObject"
          ],
          Resource = [
            "arn:aws:s3:::${var.snowflake_aws_s3_stage_bucket_name}",
            "arn:aws:s3:::${var.snowflake_aws_s3_stage_bucket_name}/*"
          ]
        }
      ] : [],
      [
        {
          Effect = "Allow",
          Action = [
            "sqs:DeleteMessage",
            "sqs:GetQueueUrl",
            "sqs:ListQueues",
            "sqs:ChangeMessageVisibility",
            "sqs:SendMessageBatch",
            "sqs:ReceiveMessage",
            "sqs:SendMessage",
            "sqs:DeleteMessageBatch",
            "sqs:ChangeMessageVisibilityBatch"
          ],
          Resource = [
            "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.sqs_queue_name}"
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:DescribeLogStreams"
          ],
          Resource = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.cloudwatch_log_group_name}:*"
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "cloudwatch:ListMetrics",
            "cloudwatch:PutMetricData"
          ],
          Resource = "*"
        }
      ]
    )
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.iam_role_loader.name
  policy_arn = aws_iam_policy.iam_policy_loader.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-snowflake-loader"
  role = aws_iam_role.iam_role_loader.name
}

# --- EC2: Security Group Rules

resource "aws_security_group" "sg" {
  name   = "${var.name}-snowflake-loader"
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "ingress_tcp_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_ip_allowlist
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egress_tcp_80" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egress_tcp_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

# Needed for clock synchronization
resource "aws_security_group_rule" "egress_udp_123" {
  type              = "egress"
  from_port         = 123
  to_port           = 123
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

# --- EC2: Auto-scaling group & Launch Configurations

locals {
  resolvers_raw = concat(var.default_iglu_resolvers, var.custom_iglu_resolvers)

  resolvers_open = [
    for resolver in local.resolvers_raw : merge(
      {
        name           = resolver["name"],
        priority       = resolver["priority"],
        vendorPrefixes = resolver["vendor_prefixes"],
        connection = {
          http = {
            uri = resolver["uri"]
          }
        }
      }
    ) if resolver["api_key"] == ""
  ]

  resolvers_closed = [
    for resolver in local.resolvers_raw : merge(
      {
        name           = resolver["name"],
        priority       = resolver["priority"],
        vendorPrefixes = resolver["vendor_prefixes"],
        connection = {
          http = {
            uri    = resolver["uri"]
            apikey = resolver["api_key"]
          }
        }
      }
    ) if resolver["api_key"] != ""
  ]

  resolvers = flatten([
    local.resolvers_open,
    local.resolvers_closed
  ])

  iglu_resolver = templatefile("${path.module}/templates/iglu_resolver.json.tmpl", {
    resolvers = jsonencode(local.resolvers)
  })

  config = templatefile("${path.module}/templates/config.json.tmpl", {
    region                     = data.aws_region.current.name
    message_queue              = var.sqs_queue_name
    sf_username                = var.snowflake_loader_user
    sf_password                = var.snowflake_password
    sf_region                  = var.snowflake_region
    sf_account                 = var.snowflake_account
    sf_wh_name                 = var.snowflake_warehouse
    sf_db_name                 = var.snowflake_database
    sf_role                    = var.snowflake_loader_role
    sf_transformed_stage       = var.snowflake_transformed_stage_name
    sf_schema                  = var.snowflake_schema
    shredder_output            = var.snowflake_aws_s3_transformed_stage_url
    sf_max_error_given         = var.max_error != -1
    sf_max_error               = var.max_error
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
    folder_monitoring_enabled  = var.folder_monitoring_enabled
    sf_folder_monitoring_stage = var.snowflake_monitoring_stage_name
    folder_monitoring_staging  = var.snowflake_aws_s3_folder_monitoring_stage_url
    folder_monitoring_period   = var.folder_monitoring_period
    folder_monitoring_since    = var.folder_monitoring_since
    folder_monitoring_until    = var.folder_monitoring_until
    health_check_enabled       = var.health_check_enabled
    health_check_freq          = var.health_check_freq
    health_check_timeout       = var.health_check_timeout
    retry_queue_enabled        = var.retry_queue_enabled
    retry_period               = var.retry_period
    retry_queue_size           = var.retry_queue_size
    retry_queue_max_attempt    = var.retry_queue_max_attempt
    retry_queue_interval       = var.retry_queue_interval
  })

  user_data = templatefile("${path.module}/templates/user-data.sh.tmpl", {
    config        = local.config
    iglu_resolver = local.iglu_resolver
    version       = local.app_version

    telemetry_script = join("", module.telemetry.*.amazon_linux_2_user_data)

    cloudwatch_logs_enabled   = var.cloudwatch_logs_enabled
    cloudwatch_log_group_name = local.cloudwatch_log_group_name
  })
}

resource "aws_launch_configuration" "lc" {
  name_prefix = "${var.name}-snowflake-loader"

  image_id             = var.amazon_linux_2_ami_id == "" ? data.aws_ami.amazon_linux_2.id : var.amazon_linux_2_ami_id
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  security_groups      = [aws_security_group.sg.id]
  user_data            = local.user_data

  # Note: Required if deployed in a public subnet
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = true
    encrypted             = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "tags" {
  source  = "snowplow-devops/tags/aws"
  version = "0.1.2"

  tags = local.tags
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.name}-snowflake-loader"

  max_size = 1
  min_size = 1

  launch_configuration = aws_launch_configuration.lc.name

  health_check_grace_period = 300
  health_check_type         = "EC2"

  vpc_zone_identifier = var.subnet_ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
    triggers = ["tag"]
  }

  tags = module.tags.asg_tags
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
