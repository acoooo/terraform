resource "aws_s3_bucket" "main_bucket" {
    bucket = "acn-main-bucket-1"
    acl = "private"
}