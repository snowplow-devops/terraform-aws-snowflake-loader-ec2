variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "app_version" {
  type  = string
}

variable "vpc_id" {
  description = "The VPC to deploy Loader within"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnets to deploy Loader across"
  type        = list(string)
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public ip address to this instance"
  type        = bool
  default     = true
}

variable "ssh_key_name" {
  description = "The name of the SSH key-pair to attach to all EC2 nodes deployed"
  type        = string
}

variable "ssh_ip_allowlist" {
  description = "The list of CIDR ranges to allow SSH traffic from"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "amazon_linux_2_ami_id" {
  description = "The AMI ID to use which must be based of of Amazon Linux 2; by default the latest community version is used"
  default     = ""
  type        = string
}

variable "tags" {
  description = "The tags to append to this resource"
  default     = {}
  type        = map(string)
}

variable "cloudwatch_logs_enabled" {
  description = "Whether application logs should be reported to CloudWatch"
  default     = true
  type        = bool
}

variable "cloudwatch_logs_retention_days" {
  description = "The length of time in days to retain logs for"
  default     = 7
  type        = number
}

# --- Configuration options

variable "sqs_queue_name" {
  description = "SQS queue name"
  type        = string
}

# --- Iglu Resolver

variable "default_iglu_resolvers" {
  description = "The default Iglu Resolvers that will be used by Stream Shredder"
  default = [
    {
      name            = "Iglu Central"
      priority        = 10
      uri             = "http://iglucentral.com"
      api_key         = ""
      vendor_prefixes = []
    },
    {
      name            = "Iglu Central - Mirror 01"
      priority        = 20
      uri             = "http://mirror01.iglucentral.com"
      api_key         = ""
      vendor_prefixes = []
    }
  ]
  type = list(object({
    name            = string
    priority        = number
    uri             = string
    api_key         = string
    vendor_prefixes = list(string)
  }))
}

variable "custom_iglu_resolvers" {
  description = "The custom Iglu Resolvers that will be used by Stream Shredder"
  default     = []
  type = list(object({
    name            = string
    priority        = number
    uri             = string
    api_key         = string
    vendor_prefixes = list(string)
  }))
}

variable "iam_permissions_boundary" {
  default = ""
  type  = string
}

variable "telemetry_script" {
  type  = string
}
