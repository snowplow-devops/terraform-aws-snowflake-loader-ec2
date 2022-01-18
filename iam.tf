data "aws_iam_policy_document" "snowflake_load_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
    resources = ["arn:aws:s3:::${var.stage_bucket_name}/${trimsuffix(var.stage_prefix, "/")}/*"]
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values = ["${trimsuffix(var.stage_prefix, "/")}/*"]
    }
    resources = ["arn:aws:s3:::${var.stage_bucket_name}"]
  }
}

data "aws_iam_policy_document" "snowflake_load_assume_role_policy_storage_integration" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [snowflake_storage_integration.integration.storage_aws_iam_user_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [snowflake_storage_integration.integration.storage_aws_external_id]
    }
  }
}

resource "aws_iam_policy" "snowflakedb_load_policy" {
  name        = local.snowflake_load_role_name
  description = "Access policy for the SnowflakeLoadRole"
  policy      = data.aws_iam_policy_document.snowflake_load_policy.json
}

resource "aws_iam_role" "snowflakedb_load_role" {
  name                 = local.snowflake_load_role_name
  description          = "Role for the Snowplow Snowflake Loader to assume"
  max_session_duration = 43200
  assume_role_policy   = data.aws_iam_policy_document.snowflake_load_assume_role_policy_storage_integration.json

  permissions_boundary = var.iam_permissions_boundary
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = join("", aws_iam_role.snowflakedb_load_role.*.name)
  policy_arn = join("", aws_iam_policy.snowflakedb_load_policy.*.arn)
}
