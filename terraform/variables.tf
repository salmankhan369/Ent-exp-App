variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Primary AWS Region"
}

variable "project_name" {
  type        = string
  default     = "ent-exp-app"
  description = "Project Resource Prefix"
}