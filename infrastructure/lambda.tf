### CONVERTER LAMBDA ###


resource "aws_lambda_function" "converter" {
  # create lambda function for actual conversion logic
  filename      = "${path.root}/../src/converter_lambda.zip"
  function_name = "carrier-pigeon-converter-lambda-${var.env_name}"
  role          = aws_iam_role.converter.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
}

# resource "aws_lambda_event_source_mapping" "sqs" {
#   # tell converter lambda to be invoked by sqs messages
#   event_source_arn = aws_sqs_queue.job_queue.arn
#   function_name    = aws_lambda_function.converter.arn
# }

resource "aws_iam_role" "converter" {
  # create iam role for converter lambda to assume
  name = "carrier-pigeon-converter-lambda-${var.env_name}"
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
  name = "carrier-pigeon-converter-lambda-logs-${var.env_name}"
  role = aws_iam_role.converter.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.converter.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy" "converter_sqs" {
  # create iam policy for converter lambda to poll sqs
  name = "carrier-pigeon-converter-lambda-sqs-${var.env_name}"
  role = aws_iam_role.converter.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
        ]
        Effect   = "Allow"
        Resource = "${aws_sqs_queue.job_queue.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy" "converter_s3" {
  # create iam policy for converter lambda to upload to s3
  name = "carrier-pigeon-converter-lambda-s3-${var.env_name}"
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

resource "aws_cloudwatch_log_group" "converter" {
  # create log group for converter lambda
  name              = "/aws/lambda/${aws_lambda_function.converter.function_name}"
  retention_in_days = 1
}


### RETRIEVAL LAMBDA ###


resource "aws_lambda_function" "retrieval" {
  # create lambda function for actual conversion logic
  filename      = "${path.root}/../src/retrieval_lambda.zip"
  function_name = "carrier-pigeon-retrieval-lambda-${var.env_name}"
  role          = aws_iam_role.retrieval.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_iam_role" "retrieval" {
  # create iam role for retrieval lambda to assume
  name = "carrier-pigeon-retrieval-lambda-${var.env_name}"
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
  name = "carrier-pigeon-retrieval-lambda-logs-${var.env_name}"
  role = aws_iam_role.retrieval.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.retrieval.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy" "retrieval_s3" {
  # create iam policy for retrieval lambda to read from s3
  name = "carrier-pigeon-retrieval-lambda-s3-${var.env_name}"
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

resource "aws_cloudwatch_log_group" "retrieval" {
  # create log group for retrieval lambda
  name              = "/aws/lambda/${aws_lambda_function.retrieval.function_name}"
  retention_in_days = 1
}