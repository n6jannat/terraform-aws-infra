variable "region" {
  description = "Region name LocalStack should pretend to be"
  type        = string
  default     = "ap-southeast-1"
}

variable "localstack_endpoint" {
  description = "LocalStack edge endpoint"
  type        = string
  default     = "http://localhost:4566"
}
