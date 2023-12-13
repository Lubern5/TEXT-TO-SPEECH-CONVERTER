

resource "aws_lambda_function" "text_to_speech_lambda" {
  filename      = "voice.zip" # Path to your Lambda code ZIP file
  function_name = "voice_to_speech_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.text_to_speech_bucket.bucket
    }
  }
}

resource "aws_s3_bucket" "text_to_speech_bucke3131t" {
  bucket = "lambda-text-to-speech3131"
}

resource "aws_iam_role" "lambda_role1212" {
  name = "lambda-text-to-speech-role1212"

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
}

resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyReadOnlyAccess" # Policy for Polly read-only access
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.text_to_speech_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.text_to_speech_bucket.arn
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.text_to_speech_lambda.function_name}"
  retention_in_days = 14
}
