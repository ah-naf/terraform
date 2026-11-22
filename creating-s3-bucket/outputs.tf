output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.example_bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.example_bucket.arn
}

output "versioning_status" {
  description = "Versioning status of the bucket"
  value       = aws_s3_bucket_versioning.example_versioning.versioning_configuration[0].status
}
