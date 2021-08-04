# ----------------------------------------------------------------------------------------------------------------------
# S3 Bucket

resource "aws_s3_bucket" "s3_bucket" {

  bucket = "${var.s3_bucket_unique_identifier}-${var.application_name}"
  acl    = "private"
  tags   = var.common_tags

  lifecycle_rule {
    id      = "delete-after-90-days"
    prefix  = ""
    enabled = true

    expiration {
      days = 90
    }
  }

}

resource "aws_s3_bucket_public_access_block" "example" {

  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
