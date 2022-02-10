variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "stage_bucket_name" {
  description = "Name of the S3 bucket which will be used as stage by Snowflake"
  type        = string
}

variable "transformed_stage_prefix" {
  description = "Path prefix of S3 location which will be used as transformed stage by Snowflake"
  type        = string
}

variable "folder_monitoring_stage_prefix" {
  description = "Path prefix of S3 location which will be used as folder monitoring stage by Snowflake"
  default     = ""
  type        = string
}

variable "sf_db_name" {
  description = "The name of the database to connect to"
  type        = string
}

variable "sf_wh_name" {
  description = "The name of the Snowflake warehouse to connect to"
  type        = string
}

variable "sf_wh_size" {
  description = "Size of the Snowflake warehouse to connect to"
  default     = "XSMALL"
  type        = string
}

variable "sf_wh_auto_suspend" {
  description = "Time period to wait before suspending warehouse"
  default     = 60
  type        = number
}

variable "sf_wh_auto_resume" {
  description = "Whether to enable auto resume which makes automatically resume the warehouse when any statement that requires a warehouse is submitted "
  default     = true
  type        = bool
}

variable "sf_atomic_schema_name" {
  description = "Name of the atomic schema created in Snowflake"
  default     = "ATOMIC"
  type        = string
}

variable "sf_file_format_name" {
  description = "Name of the Snowflake file format which is used by stage"
  default     = "SNOWPLOW_ENRICHED_JSON"
  type        = string
}

variable "sf_loader_password" {
  description = "The password to use to connect to the database"
  type        = string
  sensitive   = true
}

variable "iam_permissions_boundary" {
  description = "The permissions boundary ARN to set on IAM roles created"
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "The VPC to deploy Loader within"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnets to deploy Loader across"
  type        = list(string)
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public ip address to this instance"
  type        = bool
  default     = true
}

variable "ssh_key_name" {
  description = "The name of the SSH key-pair to attach to all EC2 nodes deployed"
  type        = string
}

variable "ssh_ip_allowlist" {
  description = "The list of CIDR ranges to allow SSH traffic from"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "amazon_linux_2_ami_id" {
  description = "The AMI ID to use which must be based of of Amazon Linux 2; by default the latest community version is used"
  default     = ""
  type        = string
}

variable "tags" {
  description = "The tags to append to this resource"
  default     = {}
  type        = map(string)
}

variable "cloudwatch_logs_enabled" {
  description = "Whether application logs should be reported to CloudWatch"
  default     = true
  type        = bool
}

variable "cloudwatch_logs_retention_days" {
  description = "The length of time in days to retain logs for"
  default     = 7
  type        = number
}

# --- Configuration options

variable "sqs_queue_name" {
  description = "SQS queue name"
  type        = string
}

variable "sf_region" {
  description = "Snowflake account region"
  type        = string
}

variable "sf_account" {
  description = "Snowflake account name"
  type        = string
}

variable "folder_monitoring_enabled" {
  description = "Whether folder monitoring should be activated or not"
  default     = false
  type        = bool
}

variable "sf_max_error" {
  description = "A table copy statement will skip an input file when the number of errors in it exceeds the specified number"
  default     = -1
  type        = number
}

variable "sp_tracking_enabled" {
  description = "Whether Snowplow tracking should be activated or not"
  default     = false
  type        = bool
}

variable "sp_tracking_app_id" {
  description = "App id for Snowplow tracking"
  default     = ""
  type        = string
}

variable "sp_tracking_collector_url" {
  description = "Collector URL for Snowplow tracking"
  default     = ""
  type        = string
}

variable "sentry_enabled" {
  description = "Whether Sentry should be enabled or not"
  default     = false
  type        = bool
}

variable "sentry_dsn" {
  description = "DSN for Sentry instance"
  default     = ""
  type        = string
}

variable "statsd_enabled" {
  description = "Whether Statsd should be enabled or not"
  default     = false
  type        = bool
}

variable "statsd_host" {
  description = "Hostname of StatsD server"
  default     = ""
  type        = string
}

variable "statsd_port" {
  description = "Port of StatsD server"
  default     = -1
  type        = number
}

variable "stdout_metrics_enabled" {
  description = "Whether logging metrics to stdout should be activated or not"
  default     = false
  type        = bool
}

variable "webhook_enabled" {
  description = "Whether webhook should be enabled or not"
  default     = false
  type        = bool
}

variable "webhook_collector" {
  description = "URL of webhook collector"
  default     = ""
  type        = string
}

variable "folder_monitoring_period" {
  description = "How often to folder should be checked by folder monitoring"
  default     = "8 hours"
  type        = string
}

variable "folder_monitoring_since" {
  description = "Specifies since when folder monitoring will check"
  default     = "14 days"
  type        = string
}

variable "folder_monitoring_until" {
  description = "Specifies until when folder monitoring will check"
  default     = "6 hours"
  type        = string
}

variable "health_check_enabled" {
  description = "Whether health check should be enabled or not"
  default     = false
  type        = bool
}

variable "health_check_freq" {
  description = "Frequency of health check"
  default     = ""
  type        = string
}

variable "health_check_timeout" {
  description = "How long to wait for a response for health check query"
  default     = ""
  type        = string
}

variable "retry_queue_enabled" {
  description = "Whether retry queue should be enabled or not"
  default     = false
  type        = bool
}

variable "retry_period" {
  description = "How often batch of failed folders should be pulled into a discovery queue"
  default     = ""
  type        = string
}

variable "retry_queue_size" {
  description = "How many failures should be kept in memory"
  default     = -1
  type        = number
}

variable "retry_queue_max_attempt" {
  description = "How many attempt to make for each folder"
  default     = -1
  type        = number
}

variable "retry_queue_interval" {
  description = "Artificial pause after each failed folder being added to the queue"
  default     = ""
  type        = string
}

# --- Iglu Resolver

variable "default_iglu_resolvers" {
  description = "The default Iglu Resolvers that will be used by Stream Shredder"
  default = [
    {
      name            = "Iglu Central"
      priority        = 10
      uri             = "http://iglucentral.com"
      api_key         = ""
      vendor_prefixes = []
    },
    {
      name            = "Iglu Central - Mirror 01"
      priority        = 20
      uri             = "http://mirror01.iglucentral.com"
      api_key         = ""
      vendor_prefixes = []
    }
  ]
  type = list(object({
    name            = string
    priority        = number
    uri             = string
    api_key         = string
    vendor_prefixes = list(string)
  }))
}

variable "custom_iglu_resolvers" {
  description = "The custom Iglu Resolvers that will be used by Stream Shredder"
  default     = []
  type = list(object({
    name            = string
    priority        = number
    uri             = string
    api_key         = string
    vendor_prefixes = list(string)
  }))
}

# --- Telemetry

variable "telemetry_enabled" {
  description = "Whether or not to send telemetry information back to Snowplow Analytics Ltd"
  type        = bool
  default     = true
}

variable "user_provided_id" {
  description = "An optional unique identifier to identify the telemetry events emitted by this stack"
  type        = string
  default     = ""
}
