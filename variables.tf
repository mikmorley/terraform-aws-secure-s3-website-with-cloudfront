variable "name" {
  type        = string
  description = "Specify the name of the stack/project"
  default     = "static-website"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "Set this to use a specific S3 bucket, else leave as default and a new bucket will be created."
}

variable "environment" {
  type        = string
  default     = "Production"
  description = "Used to determine the environment type, e.g. Development, Staging, Production etc."
}
