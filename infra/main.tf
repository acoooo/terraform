output "user-info" {
  value = aws_iam_user.user
}

output "cloudfront-domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}