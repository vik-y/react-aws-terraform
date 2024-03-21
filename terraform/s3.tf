# NOTE: Comment out the terraform block if you are running locally to avoid using remote state
terraform {
  backend "s3" {
    bucket = "kubernetes-takemetoprod"  # Your S3 bucket name
    key    = "react-aws-terraform-tf-state/terraform.tfstate"  # Path to the state file
    region = "us-east-1"  # Your AWS region
  }
}

# Create s3 bucket using s3-bucket module 
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = "public-read"

  versioning = {
    enabled = true
  }

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  # allow cloudfront access to the bucket
  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_bucket_policy.json

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Policy to be attached to the S3 bucket to allow CloudFront access
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}



module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.2.0"

  origin = {
    s3 = {
      domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      origin_id   = var.bucket_name
      origin_access_control = "s3" 
    }
  }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution pointing to ${var.bucket_name}"
  default_root_object = var.cloudfront_default_root_object
  price_class         = var.cloudfront_price_class
  create_origin_access_control = true

  origin_access_control = {
    s3 = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }



  default_cache_behavior = {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name
    forwarded_values = {
      query_string = false
      cookies = {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  # To add an alias you must also add a certificate for that alias in ACM
  # adding certificate is mandatory for aliases - so ignoring this for now 
  # aliases = ["reactdemo.takemetoprod.com"]
}

# Output the S3 bucket domain name
output "s3_bucket_domain_name" {
  value = module.s3_bucket.s3_bucket_bucket_regional_domain_name
}

# Output the CloudFront domain name
output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}

# Output the CloudFront distribution ID
output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}





