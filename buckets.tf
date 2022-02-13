resource "aws_s3_bucket" "main_bucket-1" {
  bucket = "acn-main-bucket-1"
  acl    = "private"
}

resource "aws_s3_bucket" "main_bucket-2" {
  bucket = "acn-main-bucket-2"
  acl    = "private"
}