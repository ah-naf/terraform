variable "bucket_prefix" {
  description = "Prefix for bucket names. S3 names are globally unique, so change this if apply fails with BucketAlreadyExists"
  type        = string
  default     = "iam-demo"
}

variable "bucket_suffixes" {
  description = "One bucket is created per suffix"
  type        = set(string)
  default     = ["allowed", "denied"]
}

variable "user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "demo-user"
}
