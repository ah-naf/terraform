output "bucket_names" {
  description = "Created bucket names, keyed by suffix"
  value       = { for k, b in aws_s3_bucket.this : k => b.bucket }
}

output "user_name" {
  description = "Name of the IAM user"
  value       = aws_iam_user.this.name
}

output "role_arn" {
  description = "ARN of the role the user assumes"
  value       = aws_iam_role.this.arn
}

output "access_key_id" {
  description = "Access key ID of the IAM user"
  value       = aws_iam_access_key.this.id
}

output "secret_access_key" {
  description = "Secret access key of the IAM user. Read with: terraform output -raw secret_access_key"
  value       = aws_iam_access_key.this.secret
  sensitive   = true
}
