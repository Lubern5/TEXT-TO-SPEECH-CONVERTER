provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-text-to-speech-role2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  # Optionally, you can attach policies to this role
  # For example:
  # policy_arns = ["arn:aws:iam::aws:policy/AmazonPollyReadOnlyAccess"]
}
