[![Release][release-image]][release] [![CI][ci-image]][ci] [![License][license-image]][license] [![Registry][registry-image]][registry] [![Source][source-image]][source]

# terraform-aws-snowflake-loader-ec2

A Terraform module which deploys the Snowplow Snowflake Loader on an EC2 node.

## Telemetry

This module by default collects and forwards telemetry information to Snowplow to understand how our applications are being used.  No identifying information about your sub-account or account fingerprints are ever forwarded to us - it is very simple information about what modules and applications are deployed and active.

If you wish to subscribe to our mailing list for updates to these modules or security advisories please set the `user_provided_id` variable to include a valid email address which we can reach you at.

### How do I disable it?

To disable telemetry simply set variable `telemetry_enabled = false`.

### What are you collecting?

For details on what information is collected please see this module: https://github.com/snowplow-devops/terraform-snowplow-telemetry

## Usage

Snowflake Loader loads transformed events from S3 bucket to Snowflake. 

Events are initially transformed to wide row format by transformer. After transformation is finished, transformer sends SQS message to given SQS queue. SQS message contains pieces of information related with transformed events. These are the S3 location of transformed events and the keys of the custom schemas found in the transformed events. Snowflake Loader gets messages from common SQS queue and loads transformed events to Snowflake. The events which are loaded to Snowflake are the ones which where indicated by the processed SQS message.

The `snowflake_*` inputs are meant to be obtained from outputs of the [terraform-aws-snowflake-loader-setup](https://github.com/snowplow-devops/terraform-aws-snowflake-loader-setup/).

Details on `snowflake` provider configuration described at the same [page](https://github.com/snowplow-devops/terraform-aws-snowflake-loader-setup/).

The `snowflake_region` and `snowflake_account` should be supplied directly. 

See example below:

```hcl
provider "aws" {
  region = "eu-central-1"
}

provider "snowflake" {
  username         = "service_user"
  account          = var.snowflake_account
  region           = var.snowflake_region
  role             = "ACCOUNTADMIN"
  private_key_path = "/path/to/private/key"
}

module "snowflake_setup" {
  source = "snowplow-devops/snowflake-loader-setup/aws"

  name               = "snowplow"
  stage_bucket_name  = "stage_bucket"
  account_id         = "000000000"
  sf_loader_password = "example_password"
}

module "s3_bucket" {
  source = "snowplow-devops/s3-bucket/aws"

  bucket_name = var.stage_bucket
}

resource "aws_sqs_queue" "message_queue" {
  content_based_deduplication = true
  kms_master_key_id           = "alias/aws/sqs"
  name                        = "${var.queue_name}.fifo"
  fifo_queue                  = true
}

resource "aws_key_pair" "sf_loader" {
  key_name   = "sf_loader_key_name"
  public_key = var.ssh_public_key
}

module "snowflake_loader" {
  source = "snowplow-devops/snowflake-loader-ec2/aws"

  name                                                   = var.name
  vpc_id                                                 = var.vpc_id
  subnet_ids                                             = var.subnet_ids
  ssh_key_name                                           = aws_key_pair.sf_loader.key_name
  ssh_ip_allowlist                                       = ["0.0.0.0/0"]
  iam_permissions_boundary                               = var.iam_permissions_boundary
  sqs_queue_name                                         = aws_sqs_queue.message_queue.name
  snowflake_region                                       = var.snowflake_region
  snowflake_account                                      = var.snowflake_account
  snowflake_loader_user                                  = module.snowflake_setup.snowflake_loader_user
  snowflake_password                                     = module.snowflake_setup.snowflake_password
  snowflake_loader_role                                  = module.snowflake_setup.snowflake_loader_role
  snowflake_warehouse                                    = module.snowflake_setup.snowflake_warehouse
  snowflake_database                                     = module.snowflake_setup.snowflake_database
  snowflake_schema                                       = module.snowflake_setup.snowflake_schema
  snowflake_transformed_stage_name                       = module.snowflake_setup.snowflake_transformed_stage_name
  snowflake_monitoring_stage_name                        = module.snowflake_setup.snowflake_monitoring_stage_name
  snowflake_region                                       = module.snowflake_setup.snowflake_region
  snowflake_account                                      = module.snowflake_setup.snowflake_account
  snowflake_aws_s3_transformed_stage_url                 = module.snowflake_setup.snowflake_aws_s3_transformed_stage_url
  snowflake_aws_s3_folder_monitoring_stage_url           = module.snowflake_setup.snowflake_aws_s3_folder_monitoring_stage_url
  snowflake_aws_storage_external_id                      = module.snowflake_setup.snowflake_aws_storage_external_id
  snowflake_aws_iam_storage_integration_user_arn         = module.snowflake_setup.aws_iam_storage_integration_user_arn
  snowflake_aws_iam_load_role_name                       = module.snowflake_setup.aws_iam_load_role_name
  snowflake_aws_s3_stage_bucket_name                     = module.snowflake_setup.aws_s3_stage_bucket_name
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.45.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.45.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | snowplow-devops/tags/aws | 0.1.2 |
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | A name which will be prepended to the resources created | `string` | n/a | yes |
| <a name="input_snowflake_account"></a> [snowflake\_account](#input\_snowflake\_account) | Snowflake account | `string` | n/a | yes |
| <a name="input_snowflake_aws_s3_stage_bucket_name"></a> [snowflake\_aws\_s3\_stage\_bucket\_name](#input\_snowflake\_aws\_s3\_stage\_bucket\_name) | AWS stage bucket | `string` | n/a | yes |
| <a name="input_snowflake_aws_s3_transformed_stage_url"></a> [snowflake\_aws\_s3\_transformed\_stage\_url](#input\_snowflake\_aws\_s3\_transformed\_stage\_url) | AWS bucket url of transformed stage | `string` | n/a | yes |
| <a name="input_snowflake_database"></a> [snowflake\_database](#input\_snowflake\_database) | Snowflake database name | `string` | n/a | yes |
| <a name="input_snowflake_loader_role"></a> [snowflake\_loader\_role](#input\_snowflake\_loader\_role) | Snowflake role for loading snowplow data | `string` | n/a | yes |
| <a name="input_snowflake_loader_user"></a> [snowflake\_loader\_user](#input\_snowflake\_loader\_user) | Snowflake username used by loader to perform loading | `string` | n/a | yes |
| <a name="input_snowflake_password"></a> [snowflake\_password](#input\_snowflake\_password) | Password for snowflake\_loader\_user used by loader to perform loading | `string` | n/a | yes |
| <a name="input_snowflake_region"></a> [snowflake\_region](#input\_snowflake\_region) | Snowflake region | `string` | n/a | yes |
| <a name="input_snowflake_schema"></a> [snowflake\_schema](#input\_snowflake\_schema) | Snowflake schema name | `string` | n/a | yes |
| <a name="input_snowflake_transformed_stage_name"></a> [snowflake\_transformed\_stage\_name](#input\_snowflake\_transformed\_stage\_name) | Name of transformed stage | `string` | n/a | yes |
| <a name="input_snowflake_warehouse"></a> [snowflake\_warehouse](#input\_snowflake\_warehouse) | Snowflake warehouse name | `string` | n/a | yes |
| <a name="input_sqs_queue_name"></a> [sqs\_queue\_name](#input\_sqs\_queue\_name) | SQS queue name | `string` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | The name of the SSH key-pair to attach to all EC2 nodes deployed | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnets to deploy Loader across | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to deploy Loader within | `string` | n/a | yes |
| <a name="input_amazon_linux_2_ami_id"></a> [amazon\_linux\_2\_ami\_id](#input\_amazon\_linux\_2\_ami\_id) | The AMI ID to use which must be based of of Amazon Linux 2; by default the latest community version is used | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to assign a public ip address to this instance | `bool` | `true` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Whether application logs should be reported to CloudWatch | `bool` | `true` | no |
| <a name="input_cloudwatch_logs_retention_days"></a> [cloudwatch\_logs\_retention\_days](#input\_cloudwatch\_logs\_retention\_days) | The length of time in days to retain logs for | `number` | `7` | no |
| <a name="input_custom_iglu_resolvers"></a> [custom\_iglu\_resolvers](#input\_custom\_iglu\_resolvers) | The custom Iglu Resolvers that will be used by Stream Shredder | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    uri             = string<br>    api_key         = string<br>    vendor_prefixes = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_default_iglu_resolvers"></a> [default\_iglu\_resolvers](#input\_default\_iglu\_resolvers) | The default Iglu Resolvers that will be used by Stream Shredder | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    uri             = string<br>    api_key         = string<br>    vendor_prefixes = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "api_key": "",<br>    "name": "Iglu Central",<br>    "priority": 10,<br>    "uri": "http://iglucentral.com",<br>    "vendor_prefixes": []<br>  },<br>  {<br>    "api_key": "",<br>    "name": "Iglu Central - Mirror 01",<br>    "priority": 20,<br>    "uri": "http://mirror01.iglucentral.com",<br>    "vendor_prefixes": []<br>  }<br>]</pre> | no |
| <a name="input_folder_monitoring_enabled"></a> [folder\_monitoring\_enabled](#input\_folder\_monitoring\_enabled) | Whether folder monitoring should be activated or not | `bool` | `false` | no |
| <a name="input_folder_monitoring_period"></a> [folder\_monitoring\_period](#input\_folder\_monitoring\_period) | How often to folder should be checked by folder monitoring | `string` | `"8 hours"` | no |
| <a name="input_folder_monitoring_since"></a> [folder\_monitoring\_since](#input\_folder\_monitoring\_since) | Specifies since when folder monitoring will check | `string` | `"14 days"` | no |
| <a name="input_folder_monitoring_until"></a> [folder\_monitoring\_until](#input\_folder\_monitoring\_until) | Specifies until when folder monitoring will check | `string` | `"6 hours"` | no |
| <a name="input_health_check_enabled"></a> [health\_check\_enabled](#input\_health\_check\_enabled) | Whether health check should be enabled or not | `bool` | `false` | no |
| <a name="input_health_check_freq"></a> [health\_check\_freq](#input\_health\_check\_freq) | Frequency of health check | `string` | `""` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | How long to wait for a response for health check query | `string` | `""` | no |
| <a name="input_iam_permissions_boundary"></a> [iam\_permissions\_boundary](#input\_iam\_permissions\_boundary) | The permissions boundary ARN to set on IAM roles created | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use | `string` | `"t3.micro"` | no |
| <a name="input_max_error"></a> [max\_error](#input\_max\_error) | A table copy statement will skip an input file when the number of errors in it exceeds the specified number | `number` | `-1` | no |
| <a name="input_retry_period"></a> [retry\_period](#input\_retry\_period) | How often batch of failed folders should be pulled into a discovery queue | `string` | `""` | no |
| <a name="input_retry_queue_enabled"></a> [retry\_queue\_enabled](#input\_retry\_queue\_enabled) | Whether retry queue should be enabled or not | `bool` | `false` | no |
| <a name="input_retry_queue_interval"></a> [retry\_queue\_interval](#input\_retry\_queue\_interval) | Artificial pause after each failed folder being added to the queue | `string` | `""` | no |
| <a name="input_retry_queue_max_attempt"></a> [retry\_queue\_max\_attempt](#input\_retry\_queue\_max\_attempt) | How many attempt to make for each folder | `number` | `-1` | no |
| <a name="input_retry_queue_size"></a> [retry\_queue\_size](#input\_retry\_queue\_size) | How many failures should be kept in memory | `number` | `-1` | no |
| <a name="input_sentry_dsn"></a> [sentry\_dsn](#input\_sentry\_dsn) | DSN for Sentry instance | `string` | `""` | no |
| <a name="input_sentry_enabled"></a> [sentry\_enabled](#input\_sentry\_enabled) | Whether Sentry should be enabled or not | `bool` | `false` | no |
| <a name="input_snowflake_aws_s3_folder_monitoring_stage_url"></a> [snowflake\_aws\_s3\_folder\_monitoring\_stage\_url](#input\_snowflake\_aws\_s3\_folder\_monitoring\_stage\_url) | AWS bucket url of folder monitoring stage | `string` | `""` | no |
| <a name="input_snowflake_monitoring_stage_name"></a> [snowflake\_monitoring\_stage\_name](#input\_snowflake\_monitoring\_stage\_name) | Name of monitoring stage | `string` | `""` | no |
| <a name="input_sp_tracking_app_id"></a> [sp\_tracking\_app\_id](#input\_sp\_tracking\_app\_id) | App id for Snowplow tracking | `string` | `""` | no |
| <a name="input_sp_tracking_collector_url"></a> [sp\_tracking\_collector\_url](#input\_sp\_tracking\_collector\_url) | Collector URL for Snowplow tracking | `string` | `""` | no |
| <a name="input_sp_tracking_enabled"></a> [sp\_tracking\_enabled](#input\_sp\_tracking\_enabled) | Whether Snowplow tracking should be activated or not | `bool` | `false` | no |
| <a name="input_ssh_ip_allowlist"></a> [ssh\_ip\_allowlist](#input\_ssh\_ip\_allowlist) | The list of CIDR ranges to allow SSH traffic from | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_statsd_enabled"></a> [statsd\_enabled](#input\_statsd\_enabled) | Whether Statsd should be enabled or not | `bool` | `false` | no |
| <a name="input_statsd_host"></a> [statsd\_host](#input\_statsd\_host) | Hostname of StatsD server | `string` | `""` | no |
| <a name="input_statsd_port"></a> [statsd\_port](#input\_statsd\_port) | Port of StatsD server | `number` | `8125` | no |
| <a name="input_stdout_metrics_enabled"></a> [stdout\_metrics\_enabled](#input\_stdout\_metrics\_enabled) | Whether logging metrics to stdout should be activated or not | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to append to this resource | `map(string)` | `{}` | no |
| <a name="input_telemetry_enabled"></a> [telemetry\_enabled](#input\_telemetry\_enabled) | Whether or not to send telemetry information back to Snowplow Analytics Ltd | `bool` | `true` | no |
| <a name="input_user_provided_id"></a> [user\_provided\_id](#input\_user\_provided\_id) | An optional unique identifier to identify the telemetry events emitted by this stack | `string` | `""` | no |
| <a name="input_webhook_collector"></a> [webhook\_collector](#input\_webhook\_collector) | URL of webhook collector | `string` | `""` | no |
| <a name="input_webhook_enabled"></a> [webhook\_enabled](#input\_webhook\_enabled) | Whether webhook should be enabled or not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | ID of the ASG |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | Name of the ASG |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | ID of the security group attached to the Snowflake Loader servers |

# Copyright and license

The Terraform AWS Snowflake Loader on EC2 project is Copyright 2022-2022 Snowplow Analytics Ltd.

Licensed under the [Apache License, Version 2.0][license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[snowflake-service-user-tutorial]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#2
[snowflake-env-vars]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#3

[release]: https://github.com/snowplow-devops/terraform-aws-snowflake-loader-ec2/releases/latest
[release-image]: https://img.shields.io/github/v/release/snowplow-devops/terraform-aws-snowflake-loader-ec2

[ci]: https://github.com/snowplow-devops/terraform-aws-snowflake-loader-ec2/actions?query=workflow%3Aci
[ci-image]: https://github.com/snowplow-devops/terraform-aws-snowflake-loader-ec2/workflows/ci/badge.svg

[license]: https://www.apache.org/licenses/LICENSE-2.0
[license-image]: https://img.shields.io/badge/license-Apache--2-blue.svg?style=flat

[registry]: https://registry.terraform.io/modules/snowplow-devops/snowflake-loader-ec2/aws/latest
[registry-image]: https://img.shields.io/static/v1?label=Terraform&message=Registry&color=7B42BC&logo=terraform

[source]: https://github.com/snowplow/snowplow
[source-image]: https://img.shields.io/static/v1?label=Snowplow&message=aws-snowflake-loader-ec2&color=0E9BA4&logo=GitHub
