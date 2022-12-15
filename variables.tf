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
  description = "S3 bucket name"
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
      resources  = []
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
  description = "(Optional) The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "(Required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
}

variable "create_s3" {
  type        = bool
  default     = false
  description = "if true, will create an S3 bucket"
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

variable "create_policy" {
  type        = bool
  default     = false
  description = "if true, will create an IAM policy of bucket"
}

variable "lifecycle_rule" {
  type        = any
  default     = []
  description = "all configiration for life cyle rule"
}

variable "create_s3_object" {
  type        = bool
  default     = false
  description = "if true, will create an object inside the bucket"
}

variable "create_s3_dynamic_object" {
  type        = bool
  default     = false
  description = "if true, will create many object inside the bucket"
}

variable "multiple_uploan_files" {
  type        = any
  default     = null
  description = "List of files to upload"

}

variable "bucket_id" {
  type        = string
  default     = ""
  description = "(Required) Name of the bucket to put the file in. Alternatively, an S3 access point ARN can be specified. If variable create_s3_object is true"
}
