variable "prefix" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "iam_role_enabled" {
  description = "Specifies whether to create necessary IAM role or not"
  type        = bool
  default     = true
}

variable "stage_bucket_name" {
  description = "Name of the S3 bucket which will be used as stage by Snowflake"
  type        = string
}

variable "snowflake_iam_load_role_name" {
  description = "Name of the IAM role used for loading to Snowflake"
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
