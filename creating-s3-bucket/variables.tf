variable "bucket_name" {
  description = "Name of the S3 bucket. Must be globally unique"
  type        = string
  default     = "my-bucket-poridhi-123"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "Dev"
}
