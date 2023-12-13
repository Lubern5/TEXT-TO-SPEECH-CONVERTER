
resource "aws_s3_bucket" "text_to_speech_bucket" {
  bucket = "lambda-text-to-speech5"
}

resource "null_resource" "synthesize_speech" {
  provisioner "local-exec" {
    command = <<-EOT
      # Use AWS CLI or other method to synthesize speech and upload to S3
      # Example:
      aws polly synthesize-speech --text 'Your text here' --output-format mp3 --voice-id Matthew output.mp3
      aws s3 cp output.mp3 s3://${aws_s3_bucket.text_to_speech_bucket.id}/mynameis.mp3
    EOT
  }
}

output "speech_file_info" {
  value = {
    bucket = aws_s3_bucket.text_to_speech_bucket.id,
    key    = "mynameis.mp3"
  }
}
