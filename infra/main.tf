output "cloudfront-domain" {
  description = "CDN URL that you can visit"
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}