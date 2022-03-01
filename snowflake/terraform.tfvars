# Will be prefixed to all resource names
# Use this to easily identify the resources created and provide entropy for subsequent environments
# Keep in mind that dash is replaced with underscore since some of the Snowflake resources are 
# having problem when dash is used in the resource name.
name = "sp"

# Name of the S3 bucket which will be used as stage by Snowflake
stage_bucket_name = "snowplow-terraform-sample-bucket-1"


# The password to use to connect to the database
sf_loader_password = "Hell0W0rld!2"

# The permissions boundary ARN to set on IAM roles created
iam_permissions_boundary = "" # e.g. "arn:aws:iam::0000000000:policy/MyAccountBoundary"
