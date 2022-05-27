### CONVERTER LAMBDA ###


resource "aws_lambda_function" "converter" {
  # create lambda function for actual conversion logic
  filename      = "${path.root}/../src/backend/converter_lambda.zip"
  function_name = "playlist-pigeon-converter-lambda-${var.env_name}"
  role          = aws_iam_role.converter.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      s3_bucket_name = "${aws_s3_bucket.playlists.bucket}"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs" {
  # tell converter lambda to be invoked by sqs messages
  event_source_arn = aws_sqs_queue.job_queue.arn
  function_name    = aws_lambda_function.converter.arn
}

resource "aws_iam_role" "converter" {
  # create iam role for converter lambda to assume
  name = "playlist-pigeon-converter-lambda-${var.env_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "converter_logs" {
  # create iam policy for converter lambda to write to logs
  name = "playlist-pigeon-converter-lambda-logs-${var.env_name}"
  role = aws_iam_role.converter.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "converter_sqs" {
  # create iam policy for converter lambda to poll sqs
  name = "playlist-pigeon-converter-lambda-sqs-${var.env_name}"
  role = aws_iam_role.converter.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = "${aws_sqs_queue.job_queue.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy" "converter_s3" {
  # create iam policy for converter lambda to upload to s3
  name = "playlist-pigeon-converter-lambda-s3-${var.env_name}"
  role = aws_iam_role.converter.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.playlists.arn}",
          "${aws_s3_bucket.playlists.arn}/*",
        ]
      }
    ]
  })
}

resource "aws_lambda_permission" "converter" {
  # tell converter lambda it can be invoked by sqs
  statement_id  = "AllowSQSInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.converter.function_name
  principal     = "sqs.amazonaws.com"
}


### RETRIEVAL LAMBDA ###


resource "aws_lambda_function" "retrieval" {
  # create lambda function for actual conversion logic
  filename      = "${path.root}/../src/backend/retrieval_lambda.zip"
  function_name = "playlist-pigeon-retrieval-lambda-${var.env_name}"
  role          = aws_iam_role.retrieval.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      s3_bucket_name = "${aws_s3_bucket.playlists.bucket}"
    }
  }
}

resource "aws_iam_role" "retrieval" {
  # create iam role for retrieval lambda to assume
  name = "playlist-pigeon-retrieval-lambda-${var.env_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "retrieval_logs" {
  # create iam policy for retrieval lambda to write to logs
  name = "playlist-pigeon-retrieval-lambda-logs-${var.env_name}"
  role = aws_iam_role.retrieval.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "retrieval_s3" {
  # create iam policy for retrieval lambda to read from s3
  name = "playlist-pigeon-retrieval-lambda-s3-${var.env_name}"
  role = aws_iam_role.retrieval.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.playlists.arn}",
          "${aws_s3_bucket.playlists.arn}/*",
        ]
      }
    ]
  })
}

resource "aws_lambda_permission" "retrieval" {
  # tell retrieval lambda it can be invoked by api gateway
  statement_id  = "AllowAPIGatewayInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.retrieval.function_name
  principal     = "apigateway.amazonaws.com"
}