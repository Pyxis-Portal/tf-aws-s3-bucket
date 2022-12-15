data "aws_iam_policy_document" "bucket_policy" {
  count = var.create_policy ? 1 : 0

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
  source         = "terraform-aws-modules/s3-bucket/aws"
  version        = "2.10.0"
  bucket         = var.s3_bucket_name
  acl            = "private"
  force_destroy  = var.s3_bucket_force_deletion
  attach_policy  = var.create_policy
  policy         = var.create_policy ? element(data.aws_iam_policy_document.bucket_policy.*.json, 0) : null
  lifecycle_rule = var.lifecycle_rule

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