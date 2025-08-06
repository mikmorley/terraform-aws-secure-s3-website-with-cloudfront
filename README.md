# aws-terraform-secure-s3-website-with-cloudfront

[![Terraform Validation](https://github.com/mikmorley/terraform-aws-secure-s3-website-with-cloudfront/actions/workflows/terraform-validation.yml/badge.svg)](https://github.com/mikmorley/terraform-aws-secure-s3-website-with-cloudfront/actions/workflows/terraform-validation.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A5%201.0-blue.svg)](https://terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-%E2%89%A5%205.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)

A complete Terraform stack to deploy a serverless static website, hosted from AWS in a secured s3 bucket, only accessible via CloudFront (no direct bucket access).

![s3-website-cloudfront](files/s3-website-cloudfront.png)

This stack should be used as a quickstart, and may require some additional tweaking to suit your needs (outside of hosting a simple single secure static website).

### Variables

Name|Type|Description|
|---|---|---|
|name|string|Specify the name of the stack/project|
|region|string|Defaults to `us-east-1`|
|s3_bucket_name|string|Set this to use a specific S3 bucket, else leave as default and a new bucket will be created.|
|environment|string|Used to determine the environment type, e.g. Development, Staging, Production etc.|
|cloudfront_aliases|list|Specify a list of CNAMEs to be associated with the site, else leave empty to use *.cloudfront.net.|
|cloudfront_certificate_arn|string|If cloudfront_aliases are defined, a ACM Certificate will also be required.|
