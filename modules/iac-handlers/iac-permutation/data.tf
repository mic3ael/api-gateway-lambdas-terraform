data "aws_caller_identity" "current" {}

data "archive_file" "main" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/archive_files/function.zip"

  depends_on = [null_resource.main]
}