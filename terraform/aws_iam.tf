# ----------------------------------------------------------------------------------------------------------------------
# S3 Role

resource "aws_iam_role" "role" {

  name               = "${var.application_name}-snowflake-role"
  description        = "Allow Snowflake to access ${var.application_name} S3 bucket"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json

}

resource "aws_iam_policy" "policy" {

  name        = "${var.application_name}-snowflake-policy"
  description = "Provide read access to ${var.application_name} S3 bucket"
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
      identifiers = [snowflake_storage_integration_aws.integration.describe_output[0].iam_user_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [snowflake_storage_integration_aws.integration.describe_output[0].external_id]
    }
  }

}

data "aws_iam_policy_document" "policy" {

  statement {
    actions   = ["s3:ListBucket"]
    resources = [local.aws_s3_bucket_arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["${local.aws_s3_bucket_arn}/*"]
  }

}
