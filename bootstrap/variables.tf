variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "ap-southeast-1"
}

variable "lock_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "terraform-state-lock"
}
