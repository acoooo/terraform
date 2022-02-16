resource "aws_s3_bucket" "site-buckets" {
  count = 2
  bucket = "${var.bucket_name}-${count.index}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "index-file" {
  key        = "index.html"
  bucket     = aws_s3_bucket.site-buckets[0].id
  source     = "../html/index.html"
    content_type = "text/html"
}

resource "aws_s3_bucket_object" "test-file" {
  key        = "test.html"
  bucket     = aws_s3_bucket.site-buckets[1].id
  source     = "../html/test.html"
    content_type = "text/html"
}


data "aws_iam_policy_document" "s3_policy" {
  count = length(aws_s3_bucket.site-buckets)
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site-buckets[count.index].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.main-distro.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "cf2s3" {
  count = length(aws_s3_bucket.site-buckets)
  bucket = "${aws_s3_bucket.site-buckets[count.index].id}"
  policy = "${data.aws_iam_policy_document.s3_policy[count.index].json}"
}