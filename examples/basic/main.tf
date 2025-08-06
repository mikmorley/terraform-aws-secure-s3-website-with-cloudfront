module "secure_s3_website" {
  source = "../../"

  name        = "my-secure-website"
  environment = "Production"
  region      = "us-east-1"

  # Optional: Use custom domain
  # cloudfront_aliases          = ["www.example.com", "example.com"]
  # cloudfront_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-a123-456a-a12b-a123b4cd56ef"
}