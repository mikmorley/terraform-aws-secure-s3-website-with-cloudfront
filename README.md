# Terraform AWS Static Website

[![Terraform Validation](https://github.com/mikmorley/terraform-aws-static-website/actions/workflows/terraform-validation.yml/badge.svg)](https://github.com/mikmorley/terraform-aws-static-website/actions/workflows/terraform-validation.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A5%201.0-blue.svg)](https://terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-%E2%89%A5%205.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)

A production-ready Terraform module that creates a secure, scalable static website infrastructure on AWS. This module provisions a private S3 bucket for hosting static content and a CloudFront distribution for global content delivery, ensuring the S3 bucket is only accessible through CloudFront (no direct public access).

![Architecture Diagram](files/s3-website-cloudfront.png)

## Features

🔒 **Security First**
- Private S3 bucket with no public access
- CloudFront Origin Access Identity (OAI) for secure content delivery
- Explicit deny policies for public access
- SSL/TLS enforced with minimum TLS 1.2
- AWS account root administrative access maintained

🚀 **Production Ready**
- CloudFront global edge locations for low latency
- Custom error pages (403/404 → error.html)
- Automatic MIME type detection
- S3 versioning enabled
- Comprehensive resource tagging

⚡ **Developer Friendly**
- Terraform Registry compliant
- Comprehensive variable validation
- Example usage included
- CI/CD pipeline with automated testing
- Detailed documentation

## Quick Start

```hcl
module "secure_website" {
  source = "mikmorley/static-website/aws"

  name        = "my-website"
  environment = "Production"
}
```

## Architecture

This module creates the following AWS resources:

- **S3 Bucket**: Private bucket for static content storage
- **S3 Bucket Policy**: Restricts access to CloudFront OAI and AWS account root
- **S3 Bucket Versioning**: Enables object versioning for content history
- **S3 Public Access Block**: Prevents any public access configuration
- **CloudFront Distribution**: Global CDN for content delivery
- **CloudFront Origin Access Identity**: Secure access from CloudFront to S3
- **S3 Objects**: Initial website files (index.html, error.html)

## Usage Examples

### Basic Usage

```hcl
module "website" {
  source = "mikmorley/static-website/aws"

  name        = "company-website"
  environment = "Production"
  region      = "us-west-2"
}

output "website_url" {
  value = "https://${module.website.cloudfront_url}"
}
```

### Custom Domain with SSL Certificate

```hcl
module "website" {
  source = "mikmorley/static-website/aws"

  name        = "company-website"
  environment = "Production"
  
  # Custom domain configuration
  cloudfront_aliases          = ["www.example.com", "example.com"]
  cloudfront_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-a123-456a-a12b-a123b4cd56ef"
}
```

### Using Existing S3 Bucket

```hcl
module "website" {
  source = "mikmorley/static-website/aws"

  name           = "company-website"
  s3_bucket_name = "my-existing-bucket"
  environment    = "Production"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the stack/project. Used for resource naming and tagging. | `string` | `"static-website"` | no |
| region | AWS region where resources will be created. | `string` | `"us-east-1"` | no |
| s3_bucket_name | Name of an existing S3 bucket to use. If empty, a new bucket will be created with the format '{name}-{account_id}'. | `string` | `""` | no |
| environment | Environment name for resource tagging (e.g., Development, Staging, Production). | `string` | `"Production"` | no |
| cloudfront_aliases | List of CNAMEs (alternate domain names) for the CloudFront distribution. Leave empty to use the default *.cloudfront.net domain. | `list(string)` | `[]` | no |
| cloudfront_certificate_arn | ARN of the AWS Certificate Manager certificate to use for CloudFront HTTPS. Required when cloudfront_aliases is specified. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront_url | The domain name of the CloudFront distribution |
| cloudfront_distribution_id | The identifier for the CloudFront distribution |
| s3_bucket_name | The name of the S3 bucket used for hosting the static website |
| s3_bucket_arn | The ARN of the S3 bucket |
| s3_bucket_domain_name | The bucket domain name of the S3 bucket |
| origin_access_identity_id | The CloudFront origin access identity ID |

## Security Considerations

### Access Control
- **S3 Bucket**: Private with no public access
- **CloudFront OAI**: Read-only access to S3 objects
- **AWS Account Root**: Full administrative access for management
- **Public Access**: Explicitly denied with conditional statements

### SSL/TLS Configuration
- **HTTPS Only**: CloudFront enforces HTTPS redirection
- **Minimum TLS 1.2**: Modern encryption standards
- **Custom Certificates**: Support for ACM certificates (must be in us-east-1)

### Content Security
- **Error Handling**: Custom 403/404 pages prevent information disclosure
- **Versioning**: S3 object versioning for content history
- **MIME Types**: Automatic content-type detection prevents XSS

## Deployment

1. **Configure AWS Credentials**
   ```bash
   aws configure
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Plan Deployment**
   ```bash
   terraform plan
   ```

4. **Apply Configuration**
   ```bash
   terraform apply
   ```

5. **Upload Website Content**
   ```bash
   aws s3 sync ./website-files s3://your-bucket-name/
   ```

## Custom Domain Setup

To use a custom domain:

1. **Create ACM Certificate** (must be in us-east-1 for CloudFront):
   ```bash
   aws acm request-certificate --domain-name example.com --domain-name www.example.com --region us-east-1
   ```

2. **Configure DNS**:
   - Create CNAME records pointing to the CloudFront distribution
   - Or use Route 53 alias records for the apex domain

3. **Update Module Configuration**:
   ```hcl
   cloudfront_aliases          = ["www.example.com", "example.com"]
   cloudfront_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/..."
   ```

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to the `main` branch.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Michael Morley**
- Email: [michael@morley.cloud](mailto:michael@morley.cloud)
- Website: [https://michael.morley.cloud](https://michael.morley.cloud)
- GitHub: [@mikmorley](https://github.com/mikmorley)

## Support

For questions, issues, or contributions:
- 🐛 [Report Issues](https://github.com/mikmorley/terraform-aws-static-website/issues)
- 📖 [View Documentation](https://github.com/mikmorley/terraform-aws-static-website)
- 💡 [Request Features](https://github.com/mikmorley/terraform-aws-static-website/issues)
