output "permutation_lambda_function_data" {
  value = { name : aws_lambda_function.permutation.function_name, invoke_arn : aws_lambda_function.permutation.invoke_arn }
}
