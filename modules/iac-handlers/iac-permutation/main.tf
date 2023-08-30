//TODO: create a lambda module

locals {
  prefix     = "${var.env}-permutation"
  account_id = data.aws_caller_identity.current.account_id
}

resource "null_resource" "main" {
  triggers = {
    updated_at = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    yarn
    EOF

    working_dir = "${path.module}/function"
  }
}

resource "aws_lambda_function" "permutation" {
  filename         = "${path.module}/archive_files/function.zip"
  function_name    = "${local.prefix}-lambda"
  role             = aws_iam_role.lambda.arn
  timeout          = 300
  handler          = "src/index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.main.output_base64sha256
}
