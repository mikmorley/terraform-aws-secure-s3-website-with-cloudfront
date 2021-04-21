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

variable "cloudfront_aliases" {
  type        = list(string)
  default     = []
  description = "Specify a list of CNAMEs to be associated with the site, else leave empty to use *.cloudfront.net."
}

variable "cloudfront_certificate_arn" {
  type    = string
  default = null
}
