# Will be prefixed to all resource names
# Use this to easily identify the resources created and provide entropy for subsequent environments
# Keep in mind that dash is replaced with underscore since some of the Snowflake resources are 
# having problem when dash is used in the resource name.
prefix = "sp"

# Specifies whether necessary IAM roles for loading should be created
iam_role_enabled = true

# Name of the S3 bucket which will be used as stage by Snowflake
stage_bucket_name = "snowplow-terraform-sample-bucket-1"

# Name of the IAM role used for loading to Snowflake
# It can be either created by this module with making 'iam_role_enabled'
# true or it can be created by somewhere else.
# Keep in mind that 'storage_aws_iam_user_arn' and 'storage_aws_external_id' will
# be needed in that case.
snowflake_iam_load_role_name = "sp-snowflake-load-role"

# Path prefix of S3 location which will be used as transformed events stage by Snowflake
transformed_stage_prefix = "example/shredded"

# Path prefix of S3 location which will be used as folder monitoring stage by Snowflake
# If it isn't given, stage for folder monitoring will not be created.
folder_monitoring_stage_prefix = "example/monitoring"

# The name of the database to connect to
sf_db_name = "test_db"

# The name of the Snowflake warehouse to connect to
sf_wh_name = "test_wh"

# The password to use to connect to the database
sf_loader_password = "Hell0W0rld!2"

# The permissions boundary ARN to set on IAM roles created
iam_permissions_boundary = "" # e.g. "arn:aws:iam::0000000000:policy/MyAccountBoundary"
