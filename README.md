# terraform-snowflake-loader

A Terraform module which creates necessary resources on Snowflake and deploys the Snowplow Snowflake Loader on EC2.

## Usage

Snowflake Loader loads transformed events from S3 bucket to Snowflake. 

Events are initially transformed to wide row format by transformer. After transformation is finished, transformer sends SQS message to given SQS queue. SQS message contains pieces of information related with transformed events. These are S3 location of transformed events, keys of the custom schemas found in the transformed events. Snowflake Loader gets messages from common SQS queue and loads transformed events to Snowflake. The events which is loaded to Snowflake are the ones which their location is specified in the received SQS message.

You will need service user to be able to create necessary Snowflake resources. You can [follow this tutorial][snowflake-service-user-tutorial] to do that. After creating the user with public key, you can either pass necessary values to Snowflake provider directly similar to example in the below or you can set respective environment variables as [described in here][snowflake-env-vars].

```hcl
provider "aws" {
  region = "eu-central-1"
}

provider "snowflake" {
  username = var.sf_operator_username
  account  = var.sf_account
  region   = var.sf_region
  role     = var.sf_operator_user_role
  private_key_path = var.sf_private_key_path
}

resource "aws_s3_bucket" "shredder_output" {
  bucket = var.name
  acl    = "private"
}

resource "aws_sqs_queue" "message_queue" {
  content_based_deduplication = true
  kms_master_key_id           = "alias/aws/sqs"
  name                        = var.queue_name
  fifo_queue                  = true
}

resource "aws_key_pair" "sf_loader" {
  key_name   = "sf_loader_key_name"
  public_key = var.ssh_public_key
}

module "snowflake_loader" {
  source = "terraform-snowflake-loader"

  name             = var.name
  vpc_id           = var.vpc_id
  subnet_ids       = var.subnet_ids
  ssh_key_name     = aws_key_pair.sf_loader.key_name
  ssh_ip_allowlist = ["0.0.0.0/0"]

  stage_bucket_name        = aws_s3_bucket.shredder_output.id
  transformed_stage_prefix = "prefix"
  sf_db_name               = "SF_DB_NAME"
  sf_wh_name               = "SF_WH_NAME"
  sf_loader_password       = "super_password"
  sqs_queue_name           = aws_sqs_queue.message_queue.name
}
```

[snowflake-service-user-tutorial]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#2
[snowflake-env-vars]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#3
