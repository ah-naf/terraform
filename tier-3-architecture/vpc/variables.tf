variable "vpc_name" {
  description = "Name tag of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_description" {
  description = "Description tag of the VPC"
  type        = string
  default     = "This is my VPC"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  description = "Enable DNS resolution in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "igw_name" {
  description = "Name tag of the internet gateway"
  type        = string
  default     = "my-igw"
}
