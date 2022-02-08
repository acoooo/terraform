resource "aws_iam_user" "user" {
  name = "app-user"
}

resource "aws_iam_user_policy_attachment" "attach-s3-read-only" {
  user       = aws_iam_user.user.name
  count      = "${length(var.policy_arn)}"
  policy_arn = "${var.policy_arn[count.index]}"
}

