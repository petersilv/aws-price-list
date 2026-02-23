# ----------------------------------------------------------------------------------------------------------------------
# S3 Notification

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = var.aws_s3_bucket_id

  queue {
    id        = "snowflake-sqs"
    queue_arn = snowflake_pipe.pipe.notification_channel
    events    = ["s3:ObjectCreated:*"]
  }

}
