
# ----------------------------------------------------------------------------------------------------------------------
# S3 Role

resource "aws_iam_role" "role" {

  name               = "${var.application_one_word}-role"
  description        = "Allow Snowflake to access ${var.application} S3 bucket"
  tags               = var.common_tags
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json

}

resource "aws_iam_policy" "policy" {

  name        = "${var.application_one_word}-policy"
  description = "Provide read access to ${var.application} S3 bucket"
  tags        = var.common_tags
  policy      = data.aws_iam_policy_document.policy.json

}

resource "aws_iam_role_policy_attachment" "policy_attach" {

  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn

}

data "aws_iam_policy_document" "assume_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [snowflake_storage_integration.integration.storage_aws_iam_user_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [snowflake_storage_integration.integration.storage_aws_external_id]
    }
  }

}

data "aws_iam_policy_document" "policy" {

  statement {
    actions   = ["s3:ListBucket"]
    resources = [var.aws_s3_bucket_arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["${var.aws_s3_bucket_arn}/*"]
  }

}
