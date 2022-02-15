resource "aws_s3_bucket" "main_bucket-1" {
  bucket = "acn-main-bucket-1"
  acl    = "private"
}

resource "aws_s3_bucket" "main_bucket-2" {
  bucket = "acn-main-bucket-2"
  acl    = "private"
}

resource "aws_s3_bucket_object" "index-file" {
  key        = "index"
  bucket     = aws_s3_bucket.main_bucket-1.id
  source     = "../html/index.html"
}

resource "aws_s3_bucket_object" "test-file" {
  key        = "test"
  bucket     = aws_s3_bucket.main_bucket-2.id
  source     = "../html/test.html"
}
