variable "aws_profile" {
  default = ""
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "Default AWS region"
}

variable "cidr_start" {
  default     = "10.0"
  description = "Default CIDR block"
}

variable "environment_name" {
  default = "demo"
}
