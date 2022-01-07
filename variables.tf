variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "stage_bucket_name" {
  type  = string
}

variable "stage_prefix" {
  type  = string
}

variable "sf_operator_username" {
  type  = string
}

variable "sf_account" {
  type  = string
}

variable "sf_region" {
  type  = string
}

variable "sf_operator_user_role" {
  type  = string
}

variable "sf_private_key_path" {
  type  = string
}

variable "sf_db_name" {
  type  = string
}

variable "sf_wh_name" {
  type  = string
}

variable "sf_wh_size" {
  default = "XSMALL"
  type  = string
}

variable "sf_wh_auto_suspend" {
  default = 60
  type  = number
}

variable "sf_wh_auto_resume" {
  default = true
  type  = bool
}

variable "sf_atomic_schema_name" {
  default = "ATOMIC"
  type = string
}

variable "sf_file_format_name" {
  default = "SNOWPLOW_ENRICHED_JSON"
  type = string
}

variable "sf_stage_name" {
  default = "S3_STAGE"
  type = string
}

variable "sf_loader_password" {
  type = string
  sensitive = true
}

variable "iam_permissions_boundary" {
  default = ""
  type  = string
}
