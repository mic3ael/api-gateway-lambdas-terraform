resource "aws_apigatewayv2_api" "lambda" {
  name          = "hackworth_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "v1"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "integrations" {
  api_id             = aws_apigatewayv2_api.lambda.id
  count              = length(var.targets)
  integration_uri    = var.targets[count.index].lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "routes" {
  api_id    = aws_apigatewayv2_api.lambda.id
  count     = length(var.targets)
  route_key = "${var.targets[count.index].endpoint.method} /${var.targets[count.index].endpoint.route}"
  target    = "integrations/${aws_apigatewayv2_integration.integrations[count.index].id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  count         = length(var.targets)
  function_name = var.targets[count.index].lambda.name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

# resource "aws_apigatewayv2_model" "models" {
#   api_id       = aws_apigatewayv2_api.lambda.id
#   count        = length(var.targets)
#   content_type = "application/json"
#   name         = "example"
#   schema       = jsonencode(var.targets[count.index].endpoint.schema)
# }
