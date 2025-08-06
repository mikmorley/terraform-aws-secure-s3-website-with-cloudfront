# Basic Example

This example demonstrates the basic usage of the `terraform-aws-static-website` module.

## Usage

```hcl
module "secure_s3_website" {
  source = "../../"

  name        = "my-secure-website"
  environment = "Production"
  region      = "us-east-1"
}
```

## Running this example

1. Clone the repository
2. Navigate to this example directory
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`

The module will create:
- A private S3 bucket with versioning enabled
- A CloudFront distribution with origin access identity
- All necessary IAM policies and bucket policies

After applying, you can upload your website files to the S3 bucket and access them via the CloudFront URL.

## Custom Domain (Optional)

To use a custom domain, uncomment and configure the `cloudfront_aliases` and `cloudfront_certificate_arn` variables:

```hcl
cloudfront_aliases          = ["www.example.com", "example.com"]
cloudfront_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-a123-456a-a12b-a123b4cd56ef"
```

**Note**: The SSL certificate must be created in the `us-east-1` region for CloudFront to use it.