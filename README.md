[![License][license-image]][license]

# terraform-snowflake-loader

A Terraform module which creates necessary resources on Snowflake and deploys the Snowplow Snowflake Loader on EC2.

## Telemetry

This module by default collects and forwards telemetry information to Snowplow to understand how our applications are being used.  No identifying information about your sub-account or account fingerprints are ever forwarded to us - it is very simple information about what modules and applications are deployed and active.

If you wish to subscribe to our mailing list for updates to these modules or security advisories please set the `user_provided_id` variable to include a valid email address which we can reach you at.

### How do I disable it?

To disable telemetry simply set variable `telemetry_enabled = false`.

### What are you collecting?

For details on what information is collected please see this module: https://github.com/snowplow-devops/terraform-snowplow-telemetry
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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.45.0 |
| <a name="provider_snowflake"></a> [chanzuckerberg/snowflake](#provider\_snowflake) | >= 0.25.32 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | snowplow-devops/tags/aws | 0.1.1 |
| <a name="module_telemetry"></a> [telemetry](#module\_telemetry) | snowplow-devops/telemetry/snowplow | 0.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.lc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_tcp_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_udp_123](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_tcp_22](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [snowflake_storage_integration.integration](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/storage_integration) | resource |
| [snowflake_database.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/database) | resource |
| [snowflake_schema.atomic](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/schema) | resource |
| [snowflake_warehouse.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/warehouse) | resource |
| [snowflake_file_format.enriched](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/file_format) | resource |
| [snowflake_stage.transformed](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/stage) | resource |
| [snowflake_stage.folder_monitoring](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/stage) | resource |
| [snowflake_role.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/role) | resource |
| [snowflake_warehouse_grant.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/warehouse_grant) | resource |
| [snowflake_database_grant.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/database_grant) | resource |
| [snowflake_file_format_grant.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/file_format_grant) | resource |
| [snowflake_integration_grant.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/integration_grant) | resource |
| [snowflake_stage_grant.transformed](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/stage_grant) | resource |
| [snowflake_stage_grant.folder_monitoring](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/stage_grant) | resource |
| [snowflake_schema_grant.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/schema_grant) | resource |
| [snowflake_table_grant.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/table_grant) | resource |
| [snowflake_user.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/user) | resource |
| [snowflake_role_grants.loader](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/role_grants) | resource |
| [snowflake_table.events](https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs/resources/table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | A name which will be pre-pended to the resources created | `string` | n/a | yes |
| <a name="input_stage_bucket_name"></a> [stage\_bucket\_name](#input\_stage\_bucket\_name) | The name of the S3 bucket which will be used as stage by Snowflake | `string` | n/a | yes |
| <a name="input_transformed_stage_prefix"></a> [transformed\_stage\_prefix](#input\_transformed\_stage\_prefix) | Path prefix of S3 location which will be used as transformed stage by Snowflake | `string` | n/a | yes |
| <a name="input_folder_monitoring_stage_prefix"></a> [folder\_monitoring\_stage\_prefix](#input\_folder\_monitoring\_stage\_prefix) | Path prefix of S3 location which will be used as folder monitoring stage by Snowflake | `string` | n/a | yes |
| <a name="input_sf_db_name"></a> [sf\_db\_name](#input\_sf\_db\_name) | The name of the database to connect to | `string` | n/a | yes |
| <a name="input_sf_wh_name"></a> [sf\_wh\_name](#input\_sf\_wh\_name) | The name of the Snowflake warehouse to connect to | `string` | n/a | yes |
| <a name="input_sf_region"></a> [sf\_region](#input\_sf\_region) | Snowflake account region | `string` | n/a | yes |
| <a name="input_sf_account"></a> [sf\_account](#input\_sf\_account) | Snowflake account name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to deploy Stream Shredder within | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnets to deploy Stream Shredder across | `list(string)` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | The name of the SSH key-pair to attach to all EC2 nodes deployed | `string` | n/a | yes |
| <a name="input_sqs_queue_name"></a> [sqs\_queue\_name](#input\_sqs\_queue\_name) | The name of the SQS queue Snowflake Loader will subscribe to | `string` | n/a | yes |
| <a name="input_sf_wh_size"></a> [sf\_wh\_size](#input\_sf\_wh\_size) | Size of the Snowflake warehouse to connect to | `string` | `XSMALL` | no |
| <a name="input_sf_wh_auto_suspend"></a> [sf\_wh\_auto\_suspend](#input\_sf\_wh\_auto\_suspend) | Time period to wait before suspending warehouse | `number` | `60` | no |
| <a name="input_sf_wh_auto_resume"></a> [sf\_wh\_auto\_resume](#input\_sf\_wh\_auto\_resume) | Whether to enable auto resume which makes automatically resume the warehouse when any statement that requires a warehouse is submitted | `bool` | `true` | no |
| <a name="input_sf_atomic_schema_name"></a> [sf\_atomic\_schema\_name](#input\_sf\_atomic\_schema\_name) | The name of the atomic schema created in Snowflake | `string` | `ATOMIC` | no |
| <a name="input_sf_file_format_name"></a> [sf\_file\_format\_name](#input\_sf\_file\_format\_name) | The name of the Snowflake file format which is used by stage | `string` | `SNOWPLOW_ENRICHED_JSON` | no |
| <a name="input_sf_loader_password"></a> [sf\_loader\_password](#input\_sf\_loader\_password) | The password to use to connect to the database | `string` | `string` | no |
| <a name="input_iam_permissions_boundary"></a> [iam\_permissions\_boundary](#input\_iam\_permissions\_boundary) | The permissions boundary ARN to set on IAM roles created | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use | `string` | `"t3.micro"` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to assign a public ip address to this instance | `bool` | `true` | no |
| <a name="input_ssh_ip_allowlist"></a> [ssh\_ip\_allowlist](#input\_ssh\_ip\_allowlist) | The list of CIDR ranges to allow SSH traffic from | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_amazon_linux_2_ami_id"></a> [amazon\_linux\_2\_ami\_id](#input\_amazon\_linux\_2\_ami\_id) | The AMI ID to use which must be based of of Amazon Linux 2; by default the latest community version is used | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to append to this resource | `map(string)` | `{}` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Whether application logs should be reported to CloudWatch | `bool` | `true` | no |
| <a name="input_cloudwatch_logs_retention_days"></a> [cloudwatch\_logs\_retention\_days](#input\_cloudwatch\_logs\_retention\_days) | The length of time in days to retain logs for | `number` | `7` | no |
| <a name="input_custom_iglu_resolvers"></a> [custom\_iglu\_resolvers](#input\_custom\_iglu\_resolvers) | The custom Iglu Resolvers that will be used by Stream Shredder | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    uri             = string<br>    api_key         = string<br>    vendor_prefixes = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_default_iglu_resolvers"></a> [default\_iglu\_resolvers](#input\_default\_iglu\_resolvers) | The default Iglu Resolvers that will be used by Stream Shredder | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    uri             = string<br>    api_key         = string<br>    vendor_prefixes = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "api_key": "",<br>    "name": "Iglu Central",<br>    "priority": 10,<br>    "uri": "http://iglucentral.com",<br>    "vendor_prefixes": []<br>  },<br>  {<br>    "api_key": "",<br>    "name": "Iglu Central - Mirror 01",<br>    "priority": 20,<br>    "uri": "http://mirror01.iglucentral.com",<br>    "vendor_prefixes": []<br>  }<br>]</pre> | no |
| <a name="input_telemetry_enabled"></a> [telemetry\_enabled](#input\_telemetry\_enabled) | Whether or not to send telemetry information back to Snowplow Analytics Ltd | `bool` | `true` | no |
| <a name="input_user_provided_id"></a> [user\_provided\_id](#input\_user\_provided\_id) | An optional unique identifier to identify the telemetry events emitted by this stack | `string` | `""` | no |


# Copyright and license

The Terraform Snowflake Loader project is Copyright 2022-2022 Snowplow Analytics Ltd.

Licensed under the [Apache License, Version 2.0][license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[snowflake-service-user-tutorial]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#2
[snowflake-env-vars]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#3

[license]: https://www.apache.org/licenses/LICENSE-2.0
[license-image]: https://img.shields.io/badge/license-Apache--2-blue.svg?style=flat
