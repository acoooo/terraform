resource "aws_iam_user" "user" {
  name = "app-user"
}

resource "aws_iam_user_policy_attachment" "attach-read-only-policies" {
  user       = aws_iam_user.user.name
  count      = "${length(var.policy_arn)}"
  policy_arn = "${var.policy_arn[count.index]}"
}