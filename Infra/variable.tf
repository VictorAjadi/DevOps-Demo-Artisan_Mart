variable "region" {
  type        = string
  description = "AWS region where Artisan Mart resources will be deployed"
  default     = "us-east-1"
}

variable "key_pair_name" {
  type        = string
  description = "AWS Key Pair used for SSH access"
  default     = "artisans_mart_key_pair"
}

variable "avail_zone" {
  type        = string
  description = "Availability Zone for the subnet"
  default     = "us-east-1a"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the Artisan Mart VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type        = string
  description = "CIDR block for the Artisan Mart subnet"
  default     = "10.0.10.0/24"
}