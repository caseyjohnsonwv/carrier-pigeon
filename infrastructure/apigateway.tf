### GENERAL API STUFF ###


resource "aws_api_gateway_rest_api" "apigw" {
  # create api gateway instance
  name = "playlist-pigeon-api-gateway-${var.env_name}"
}

resource "aws_api_gateway_deployment" "deployment" {
  # create snapshot of gateway config for live deployment
  rest_api_id = aws_api_gateway_rest_api.apigw.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    # auth requests
    aws_api_gateway_integration.post_auth_lambda,
    aws_api_gateway_method.post_auth,
    # converter requests
    aws_api_gateway_integration.post_convert_sqs,
    aws_api_gateway_method.post_convert,
    aws_api_gateway_integration_response.post_convert_responses,
    # retrieval requests
    aws_api_gateway_integration.get_convert_lambda,
    aws_api_gateway_method.get_convert,
  ]
}

resource "aws_api_gateway_stage" "stage" {
  # create stage to manage versions of deployed api
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "v1"
}

resource "aws_iam_role" "apigw" {
  # create role for api gateway to assume
  name = "playlist-pigeon-api-gateway-${var.env_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com",
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "apigw_lambda" {
  # give above role access to lambda and sqs
  name = "playlist-pigeon-api-gateway-lambda-${var.env_name}"
  role = aws_iam_role.apigw.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = "*"
      }
    ]
  })
}


### ENDPOINTS ###


resource "aws_api_gateway_resource" "auth" {
  # create /auth under /v1
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "auth"
}

module "auth_endpoint_cors" {
  # enable cors on /auth
  source          = "squidfunk/api-gateway-enable-cors/aws"
  api_id          = aws_api_gateway_rest_api.apigw.id
  api_resource_id = aws_api_gateway_resource.auth.id
}

resource "aws_api_gateway_resource" "convert" {
  # create /convert under /v1
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "convert"
}

module "convert_endpoint_cors" {
  # enable cors on /convert
  source          = "squidfunk/api-gateway-enable-cors/aws"
  api_id          = aws_api_gateway_rest_api.apigw.id
  api_resource_id = aws_api_gateway_resource.convert.id
}


### AUTH ENDPOINT - POST ###


resource "aws_api_gateway_method" "post_auth" {
  # create post method for /auth
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.auth.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_auth_lambda" {
  # tell api gateway how to invoke lambda
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.auth.id
  http_method             = aws_api_gateway_method.post_auth.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.auth.invoke_arn
}


### CONVERT ENDPOINT - GET ###


resource "aws_api_gateway_method" "get_convert" {
  # create get method for /convert
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.convert.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_convert_lambda" {
  # tell api gateway how to invoke lambda
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.convert.id
  http_method             = aws_api_gateway_method.get_convert.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.retrieval.invoke_arn
}


### CONVERT ENDPOINT - POST ###


resource "aws_api_gateway_method" "post_convert" {
  # create post method for /convert
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.convert.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_convert_codes" {
  # tell api gateway to these status codes for post requests
  for_each    = toset(["201", "400", "500"])
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.convert.id
  http_method = aws_api_gateway_method.post_convert.http_method
  status_code = each.value
}

resource "aws_api_gateway_integration_response" "post_convert_responses" {
  # tell api gateway to funnel all 2xx, 4xx, 5xx into 201, 400, 500 responses above
  for_each          = aws_api_gateway_method_response.post_convert_codes
  rest_api_id       = aws_api_gateway_rest_api.apigw.id
  resource_id       = aws_api_gateway_resource.convert.id
  http_method       = each.value.http_method
  status_code       = each.value.status_code
  selection_pattern = "${substr(each.value.status_code, 0, 1)}[0-9]{2}"

  depends_on = [
    aws_api_gateway_integration.post_convert_sqs,
  ]
}

resource "aws_api_gateway_integration" "post_convert_sqs" {
  # tell api gateway how to push to sqs
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.convert.id
  http_method             = aws_api_gateway_method.post_convert.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = aws_iam_role.apigw.arn
  uri                     = "arn:aws:apigateway:${var.aws_region}:sqs:path/${aws_sqs_queue.job_queue.name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}
