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

variable "create_s3_object" {
  type        = bool
  default     = false
  description = "this create reource s3 object"
}

variable "s3_object_key" {
  type        = string
  default     = "java-basic-1.0"
  description = "Name of the object once it is in the bucket."
}

variable "s3_object_source" {
  type        = string
  default     = "java-basic-1.0.jar"
  description = "Path to a file that will be read and uploaded as raw bytes for the object content."
}

