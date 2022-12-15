output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = element(concat(module.s3_bucket.*.s3_bucket_id, [""]), 0)
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = element(concat(module.s3_bucket.*.s3_bucket_arn, [""]), 0)
}