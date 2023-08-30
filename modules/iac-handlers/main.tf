locals {
  prefix     = var.env
  account_id = data.aws_caller_identity.current.account_id
}

resource "null_resource" "main" {
  count = length(var.lambdas)
  triggers = {
    updated_at = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    yarn
    EOF

    working_dir = var.lambdas[count.index].source_dir
  }
}

resource "aws_lambda_function" "lambdas" {
  count            = length(var.lambdas)
  filename         = var.lambdas[count.index].output_path
  function_name    = "${local.prefix}-${var.lambdas[count.index].function_name}-lambda"
  role             = aws_iam_role.lambdas[count.index].arn
  timeout          = var.lambdas[count.index].timeout
  handler          = var.lambdas[count.index].handler
  runtime          = var.lambdas[count.index].runtime
  source_code_hash = data.archive_file.main[count.index].output_base64sha256
}
