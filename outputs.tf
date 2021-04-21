output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.website[0].id
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.website[0].bucket_domain_name
}