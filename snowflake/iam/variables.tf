variable "stage_bucket_name" {
  description = "Name of the S3 bucket which will be used as stage by Snowflake"
  type        = string
}

variable "snowflake_iam_load_role_name" {
  description = "Name of the IAM role used for loading to Snowflake"
  type        = string
}

variable "storage_aws_iam_user_arn" {
  description = "The AWS IAM user created for Snowflake account"
  type        = string
}

variable "storage_aws_external_id" {
  description = "The external ID that is needed to establish a trust relationship."
  type        = string
}

variable "iam_permissions_boundary" {
  description = "The permissions boundary ARN to set on IAM roles created"
  default     = ""
  type        = string
}
