data "aws_iam_policy_document" "bucket_policy" {
  dynamic "statement" {
    for_each = var.s3_access_policy

    content {
      principals {
        type        = "AWS"
        identifiers = statement.value["principals"]
      }
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }
}

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "2.10.0"
  bucket        = var.s3_bucket_name
  acl           = "private"
  force_destroy = var.s3_bucket_force_deletion
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  tags = {
    Name        = var.s3_bucket_name
    Environment = var.environment
  }

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_master_key_id
        sse_algorithm     = var.sse_algorithm
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  //  object_lock_configuration = {
  //    object_lock_enabled = "Enabled"
  //    rule = {
  //      default_retention = {
  //        mode  = "COMPLIANCE"
  //        years = 5
  //      }
  //    }
  //  }
  //  logging = {
  //    target_bucket = module.log_bucket.this_s3_bucket_id
  //    target_prefix = "log/"
  //  }

  //  lifecycle_rule = [
  //    {
  //      id      = "log"
  //      enabled = true
  //      prefix  = "log/"
  //
  //      tags = {
  //        rule      = "log"
  //        autoclean = "true"
  //      }
  //
  //      transition = [
  //        {
  //          days          = 30
  //          storage_class = "ONEZONE_IA"
  //        }, {
  //          days          = 60
  //          storage_class = "GLACIER"
  //        }
  //      ]
  //
  //      expiration = {
  //        days = 90
  //      }
  //
  //      noncurrent_version_expiration = {
  //        days = 30
  //      }
  //    },
  //    {
  //      id                                     = "log1"
  //      enabled                                = true
  //      prefix                                 = "log1/"
  //      abort_incomplete_multipart_upload_days = 7
  //
  //      noncurrent_version_transition = [
  //        {
  //          days          = 30
  //          storage_class = "STANDARD_IA"
  //        },
  //        {
  //          days          = 60
  //          storage_class = "ONEZONE_IA"
  //        },
  //        {
  //          days          = 90
  //          storage_class = "GLACIER"
  //        },
  //      ]
  //
  //      noncurrent_version_expiration = {
  //        days = 300
  //      }
  //    },
  //  ]
}

resource "aws_s3_bucket_object" "this" {
  count  = var.create_s3_object ? 1 : 0
  bucket = module.s3_bucket.s3_bucket_id
  key    = var.s3_object_key
  source = var.s3_object_source
  etag   = filemd5(var.s3_object_source)
}

resource "aws_lambda_permission" "lambda_allow_bucket_notification" {
  count         = length(var.s3_trigger_lambdas_list)
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.s3_trigger_lambdas_list[count.index]["lambda_function_arn"]
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3_bucket.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = length(var.s3_trigger_lambdas_list) > 0 ? 1 : 0
  bucket = module.s3_bucket.s3_bucket_id

  dynamic "lambda_function" {
    for_each = var.s3_trigger_lambdas_list

    content {
      id                  = lambda_function.value["id"]
      lambda_function_arn = lambda_function.value["lambda_function_arn"]
      events              = lambda_function.value["events"]
      filter_prefix       = lambda_function.value["filter_prefix"]
      filter_suffix       = lambda_function.value["filter_suffix"]
    }
  }

  depends_on = [
    aws_lambda_permission.lambda_allow_bucket_notification
  ]
}