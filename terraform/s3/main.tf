resource "aws_s3_bucket" "assets" {
  bucket = "bedrock-assets-${var.student_id}"
  tags   = local.tags
}
