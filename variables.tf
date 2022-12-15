variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "s3_bucket_name" {
  type    = string
  default = "my-bucket"
}

variable "s3_bucket_force_deletion" {
  type    = bool
  default = false
}

variable "s3_access_policy" {
  type = list(map(list(string)))
  default = [
    {
      principals = []
      actions    = []
      resouces   = []
    },
  ]
}

variable "s3_trigger_lambdas_list" {
  type = list(object({
    id                  = string
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = string
    filter_suffix       = string
  }))
  default = []
}

variable "kms_master_key_id" {
  type    = string
  default = ""
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "AES256 or aws:kms"
}