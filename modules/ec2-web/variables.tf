variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC to place the security group in"
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch the instance in (public subnet for a reachable web server)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (t3.micro is Free Tier eligible in most regions)"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI to use. Leave null to look up the latest Amazon Linux 2023 AMI."
  type        = string
  default     = null
}

variable "ami_name_filter" {
  description = "Name pattern for the Amazon-owned AMI lookup when ami_id is null"
  type        = string
  default     = "al2023-ami-2023.*-x86_64"
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH (optional)"
  type        = string
  default     = null
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH in. Keep this to your own IP, e.g. [\"203.0.113.10/32\"]."
  type        = list(string)
  default     = []
}

variable "root_volume_size" {
  description = "Root volume size in GiB"
  type        = number
  default     = 8
}

variable "tags" {
  description = "Tags applied to every resource"
  type        = map(string)
  default     = {}
}
