resource "aws_s3_bucket" "text_to_speech_bucket1212" {
  bucket = "lambda-text-to-speech2"


  # Define your ACL permissions here
  # For example:
  # grants {
  #   id          = "1"
  #   permissions = ["READ", "WRITE", "READ_ACP", "WRITE_ACP"]
  #   type        = "Group"
  #   uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
  # }
  # More grants can be added as required
}
