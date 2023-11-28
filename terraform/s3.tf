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
  
  # These configurations are needed if you want the file content to be public
  block_public_acls        = false
  block_public_policy      = false
  ignore_public_acls       = false
  restrict_public_buckets  = false

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.2.0"

  origin = [{
    domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    origin_id = var.bucket_name
  }]


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution pointing to ${var.bucket_name}"
  default_root_object = var.cloudfront_default_root_object
  price_class         = var.cloudfront_price_class

  default_cache_behavior = {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name
    forwarded_values = {
      query_string = false
      cookies      = {
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





