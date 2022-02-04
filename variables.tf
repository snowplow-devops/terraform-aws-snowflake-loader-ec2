variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "loader_enabled" {
  description = "Specifies whether to deploy loader or not"
  type        = bool
  default     = true
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
