# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

module "lambda_function" {

  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.application_short}-describeservices"
  description   = "Call the Describe Services Endpoint and write Service List to S3"
  tags          = var.common_tags
  handler       = "describe_services.main"
  runtime       = "python3.7"
  memory_size   = 512
  timeout       = 60
  publish       = true

  create_role   = false
  lambda_role   = aws_iam_role.lambda_role.arn

  create_package         = false
  local_existing_package = "../lambda/describe_services.zip"

  environment_variables = {
    S3_BUCKET = var.aws_s3_bucket_id,
    S3_PREFIX = "data/services/"
  }
  
  allowed_triggers = {
    event_rule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.event.arn
    }
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Trigger

resource "aws_cloudwatch_event_rule" "event" {

  name                = "${var.application_short}-event-rule"
  description         = "Run at 6pm UTC every Sunday"
  schedule_expression = "cron(0 18 ? * SUN *)" 
  tags                = var.common_tags

}

resource "aws_cloudwatch_event_target" "lambda" {

  rule = aws_cloudwatch_event_rule.event.name
  arn  = module.lambda_function.lambda_function_arn

}


# ----------------------------------------------------------------------------------------------------------------------
# Lambda Role

resource "aws_iam_role" "lambda_role" {

  name               = "${var.application_short}-lambda-role"
  description        = "Allow Lambda function access to ${var.application_short} S3 bucket"
  tags               = var.common_tags
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json

}

resource "aws_iam_policy" "lambda_policy" {

  name        = "${var.application_short}-lambda-policy"
  description = "Provide write access to ${var.application_short} S3 bucket"
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
    actions   = ["pricing:*"]
    resources = ["*"]
  }

} 
