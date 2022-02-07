variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "app_version" {
  type  = string
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

variable "sf_username" {
  description = "Snowflake username"
  type        = string
}

variable "sf_password" {
  description = "Password of Snowflake user"
  type        = string
  sensitive   = true
}

variable "sf_account" {
  description = "Snowflake account name"
  type        = string
}

variable "sf_wh_name" {
  description = "Snowflake warehouse name"
  type        = string
}

variable "sf_db_name" {
  description = "Snowflake database name"
  type        = string
}

variable "sf_transformed_stage" {
  description = "Snowflake stage to load transformed events"
  type        = string
}

variable "folder_monitoring_enabled" {
  description = "Whether folder monitoring should be activated or not"
  default     = false
  type        = bool
}

variable "sf_folder_monitoring_stage" {
  description = "Snowflake stage for folder monitoring"
  default     = ""
  type        = string
}

variable "sf_schema" {
  description = "Snowflake schema name"
  type        = string
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

variable "folder_monitoring_staging" {
  description = "Path where Loader could store auxiliary logs for folder monitoring"
  default     = ""
  type        = string
}

variable "folder_monitoring_period" {
  description = "How often to folder should be checked by folder monitoring"
  default     = ""
  type        = string
}

variable "folder_monitoring_since" {
  description = "Specifies since when folder monitoring will check"
  default     = ""
  type        = string
}

variable "folder_monitoring_until" {
  description = "Specifies until when folder monitoring will check"
  default     = ""
  type        = string
}

variable "shredder_output" {
  description = "Path to shredded archive"
  default     = ""
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

variable "iam_permissions_boundary" {
  default = ""
  type  = string
}

variable "telemetry_script" {
  type  = string
}
