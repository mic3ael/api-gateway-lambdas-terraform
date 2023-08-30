data "aws_caller_identity" "current" {}

data "archive_file" "main" {
  count       = length(var.lambdas)
  type        = "zip"
  source_dir  = var.lambdas[count.index].source_dir
  output_path = var.lambdas[count.index].output_path

  depends_on = [null_resource.main]
}
