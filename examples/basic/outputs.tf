output "website_url" {
  description = "The CloudFront URL for the website"
  value       = "https://${module.static_website.cloudfront_url}"
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.static_website.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID"
  value       = module.static_website.cloudfront_distribution_id
}