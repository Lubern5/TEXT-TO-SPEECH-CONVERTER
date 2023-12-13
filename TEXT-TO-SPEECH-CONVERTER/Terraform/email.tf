

resource "aws_s3_bucket" "text_to_speech_database" {
  bucket = "lamda-text-to-speech-datebase"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  // Attach policies necessary for S3, SES, and SNS access
  // Example:
  // inline_policy {
  //   name = "lambda_s3_access"
  //   policy = jsonencode({
  //     Version = "2012-10-17",
  //     Statement = [
  //       {
  //         Effect   = "Allow",
  //         Action   = ["s3:*"],
  //         Resource = aws_s3_bucket.text_to_speech_database.arn
  //       },
  //       // Add other policies as needed
  //     ]
  //   })
  // }
}

resource "aws_lambda_function" "notification_function" {
  filename = "${path.module}/email.zip"  # Path to your Lambda code ZIP file
  function_name = "notification_lambda_function"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_handler"
  runtime       = "python3.8"  # Replace with your Lambda's runtime

  // Additional environment variables, if required
  // environment {
  //   variables = {
  //     SOME_VARIABLE = "some_value"
  //   }
  // }
}

resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification_function.function_name
  principal     = "s3.amazonaws.com"
  
  source_arn = aws_s3_bucket.text_to_speech_database.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.text_to_speech_database.id
  
  lambda_function {
    lambda_function_arn = aws_lambda_function.notification_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
}
