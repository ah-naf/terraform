variable "vpc_name" {
  description = "Name of the VPC to be created"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of the subnet to be created"
  type        = string
  default     = "my-subnet"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "igw_name" {
  description = "Name of the Internet Gateway to be created"
  type        = string
  default     = "my-igw"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "ap-southeast-1a"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "my-ec2-key"
}

variable "public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "./my-ec2-key.pub"
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "ssh_access"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu)"
  type        = string
  default     = "ami-060e277c0d4cce553"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag of the EC2 instance"
  type        = string
  default     = "my-ec2-instance"
}
