# Snowplow Snowflake Resources

A Terraform module which creates necessary Snowflake resources needed by Snowplow Snowflake Loader.

## Usage

You will need service user to be able to create necessary Snowflake resources. You
can [follow this tutorial][snowflake-service-user-tutorial] to do that. After creating the user with public key, you can
either pass necessary values to Snowflake provider directly similar to example in the below or you can set respective
environment variables as [described in here][snowflake-env-vars].

### Using the module from another module

```hcl
provider "aws" {
  region = "eu-central-1"
}

provider "snowflake" {
  username         = var.sf_operator_username
  account          = var.sf_account
  region           = var.sf_region
  role             = var.sf_operator_user_role
  private_key_path = var.sf_private_key_path
}

module "snowflake_resources" {
  source = "terraform-snowplow-snowflake-resources"

  name               = "my_company"
  stage_bucket_name  = "stage_bucket"
  account_id         = "00000000"
  sf_loader_password = "example_password"
}
```

### Applying module directly

You can apply this module directly too. Initially, you need to update variables in `terraform.tfvars`
and `sf_provider_vars.sh` according to your setup. After, you need to get the variables in `sf_provider_vars.sh` to your
environment. In order to do that, you need run following command in your current shell:

```
. ./sf_provider_vars.sh
```

Variables in `sf_provider_vars.sh` is used by Snowflake and AWS terraform providers. If you don't source this script,
you can pass necessary values interactively too when `terraform apply` run.

Lastly, you need to run `terraform apply`. If everything is configured correctly, it should start to run.

[snowflake-service-user-tutorial]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#2

[snowflake-env-vars]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#3
