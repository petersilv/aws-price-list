# ----------------------------------------------------------------------------------------------------------------------
# Lambda Role

resource "aws_iam_role" "lambda_role" {

  name               = "${var.application_one_word}-lambda-role"
  description        = "Allow Lambda function access to ${var.application_one_word} S3 bucket"
  tags               = var.common_tags
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json

}

resource "aws_iam_policy" "lambda_policy" {

  name        = "${var.application_one_word}-lambda-policy"
  description = "Provide write access to ${var.application_one_word} S3 bucket"
  tags        = var.common_tags
  policy      = data.aws_iam_policy_document.lambda_policy.json

}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn

}


data "aws_iam_policy_document" "lambda_assume_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

  }

}

data "aws_iam_policy_document" "lambda_policy" {

  statement {
    actions   = ["s3:ListBucket"]
    resources = [var.aws_s3_bucket_arn]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]
    resources = ["${var.aws_s3_bucket_arn}/*"]
  }

  statement {
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "sns:Publish"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["pricing:*"]
    resources = ["*"]
  }


} 
