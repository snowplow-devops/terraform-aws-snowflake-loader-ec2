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

variable "snowflake_wh_size" {
  description = "Size of the Snowflake warehouse to connect to"
  default     = "XSMALL"
  type        = string
}

variable "snowflake_wh_auto_suspend" {
  description = "Time period to wait before suspending warehouse"
  default     = 60
  type        = number
}

variable "snowflake_wh_auto_resume" {
  description = "Whether to enable auto resume which makes automatically resume the warehouse when any statement that requires a warehouse is submitted "
  default     = true
  type        = bool
}

variable "snowflake_file_format_name" {
  description = "Name of the Snowflake file format which is used by stage"
  default     = "SNOWPLOW_ENRICHED_JSON"
  type        = string
}

variable "snowflake_loader_password" {
  description = "The password to use to connect to the database"
  type        = string
  sensitive   = true
}

variable "is_create_database" {
  description = "Should database be created set to false, if there is an existing one"
  default     = true
  type        = bool
}

variable "override_snowflake_db_name" {
  description = "Override database name, if not set it will be defaulted to uppercase var.name with _DATABASE suffix"
  default     = ""
  type        = string
}

variable "override_snowflake_wh_name" {
  description = "Override warehouse name, if not set it will be defaulted to uppercase var.name with _WAREHOUSE suffix"
  default     = ""
  type        = string
}

variable "override_folder_monitoring_stage_url" {
  description = "Override monitoring stage url, if not set it will be defaulted \"s3://$${var.stage_bucket_name}/$${var.name}/shredded/v1\""
  default     = ""
  type        = string
}

variable "override_transformed_stage_url" {
  description = "Override transformed stage url, if not set it will be defaulted \"s3://$${var.stage_bucket_name}/$${var.name}/monitoring\""
  default     = ""
  type        = string
}

variable "override_iam_loader_role_name" {
  description = "Override transformed stage url, if not set it will be var.name with -snowflakedb-load-role suffix"
  default     = ""
  type        = string
}

variable "override_snowflake_loader_user" {
  description = "Override loader user name in snowflake, if not set it will be uppercase var.name with _LOADER_USER suffix"
  default     = ""
  type        = string
}

variable "override_snowflake_loader_role" {
  description = "Override loader role ma,e in snowflake, if not set it will be uppercase var.name with _LOADER_ROLE suffix"
  default     = ""
  type        = string
}

variable "snowflake_schema" {
  description = "Schema name for snowplow data"
  default     = "ATOMIC"
  type        = string
}


variable "should_create_db" {
  description = "Should this module create a "
  default     = "ATOMIC"
  type        = string
}

variable "account_id" {
  description = "Account id"
  default     = ""
  type        = string
}

