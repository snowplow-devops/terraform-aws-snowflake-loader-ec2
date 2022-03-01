variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "stage_bucket_name" {
  description = "Name of the S3 bucket which will be used as stage by Snowflake"
  type        = string
}

variable "folder_monitoring_enabled" {
  description = "Folder monitoring loading"
  type        = bool
  default     = true
}

variable "iam_permissions_boundary" {
  description = "The permissions boundary ARN to set on IAM roles created"
  default     = ""
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

variable "sf_file_format_name" {
  description = "Name of the Snowflake file format which is used by stage"
  default     = "SNOWPLOW_ENRICHED_JSON"
  type        = string
}

variable "snowflake_loader_password" {
  description = "The password to use to connect to the database"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "Account id"
  default     = ""
  type        = string
}

