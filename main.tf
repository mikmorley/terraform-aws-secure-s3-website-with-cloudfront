data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  s3_origin_id = "s3-website"

  # If var.s3_bucket_name is not set, a new bucket will be created.
  create_bucket = var.s3_bucket_name == "" ? 1 : 0
  bucket_name   = local.create_bucket == 1 ? "${var.name}-${local.account_id}" : var.s3_bucket_name
}

# Create S3 Bucket
resource "aws_s3_bucket" "website" {
  count  = local.create_bucket
  bucket = local.bucket_name
  acl    = "private"
  policy = data.aws_iam_policy_document.s3_bucket_policy.json

  versioning {
    enabled = true
  }

  tags = {
    Environment = var.environment
  }
}

# S3 Bucket Policy allowing access from CloudFront
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "AllowAccessViaCloudFront"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
      ]
    }
  }
}

# Add initial static web files to s3 for validation of infrastructure
resource "aws_s3_bucket_object" "index" {
  depends_on = [
    aws_s3_bucket.website[0]
  ]
  bucket       = aws_s3_bucket.website[0].bucket
  key          = "index.html"
  source       = "${path.module}/files/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/files/index.html")
}

resource "aws_s3_bucket_object" "error" {
  depends_on = [
    aws_s3_bucket.website[0]
  ]
  bucket       = aws_s3_bucket.website[0].bucket
  key          = "index.html"
  source       = "${path.module}/files/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/files/error.html")
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [
    aws_s3_bucket.website[0]
  ]

  origin {
    domain_name = aws_s3_bucket.website[0].bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.name
  default_root_object = "index.html"

  #   aliases = local.domain_name

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/error.html"
  }

  wait_for_deployment = false

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${local.bucket_name}.s3.amazonaws.com"
}
