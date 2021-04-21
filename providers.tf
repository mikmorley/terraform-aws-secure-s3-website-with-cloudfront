terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = "AKIAS6ER3OA26WNKZUNA"
  secret_key = "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"
}