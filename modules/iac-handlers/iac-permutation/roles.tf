resource "aws_iam_role" "lambda" {
  name               = "${local.prefix}-lambda-role"
  assume_role_policy = templatefile("${path.module}/templates/lambda-assume-role-policy.tmpl", {})
}

resource "aws_iam_policy" "lambda" {
  name   = "${local.prefix}-lambda-policy"
  policy = templatefile("${path.module}/templates/lambda-policy.tmpl", {})
}

resource "aws_iam_role_policy_attachment" "action_handler_policy_attachment" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = aws_iam_role.lambda.name
}
