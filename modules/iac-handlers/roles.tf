resource "aws_iam_role" "lambdas" {
  count              = length(var.lambdas)
  name               = "${local.prefix}-${var.lambdas[count.index].function_name}-lambda-role"
  assume_role_policy = templatefile("${path.module}/templates/lambda-assume-role-policy.tmpl", {})
}

resource "aws_iam_policy" "lambdas" {
  count  = length(var.lambdas)
  name   = "${local.prefix}-${var.lambdas[count.index].function_name}-lambda-policy"
  policy = templatefile("${path.module}/templates/lambda-policy.tmpl", {})
}

resource "aws_iam_role_policy_attachment" "action_handler_policy_attachment" {
  count      = length(var.lambdas)
  policy_arn = aws_iam_policy.lambdas[count.index].arn
  role       = aws_iam_role.lambdas[count.index].name
}
