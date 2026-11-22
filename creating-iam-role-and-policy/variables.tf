variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_prefix" {
  description = "Prefix for bucket names. S3 names are globally unique, so change this if apply fails with BucketAlreadyExists"
  type        = string
  default     = "iam-demo"
}

variable "bucket_suffixes" {
  description = "One bucket is created per suffix. Must include allowed_bucket_suffix"
  type        = set(string)
  default     = ["allowed", "denied"]
}

variable "allowed_bucket_suffix" {
  description = "Suffix of the only bucket the role can access"
  type        = string
  default     = "allowed"
}

variable "user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "demo-user"
}

variable "role_name" {
  description = "Name of the IAM role the user assumes"
  type        = string
  default     = "demo-s3-role"
}

variable "policy_name" {
  description = "Name of the S3 access policy attached to the role"
  type        = string
  default     = "demo-s3-policy"
}
