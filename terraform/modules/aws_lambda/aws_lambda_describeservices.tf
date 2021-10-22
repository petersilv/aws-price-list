# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

module "lambda_function_describeservices" {

  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.application_name}-describeservices"
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
    S3_PREFIX = "data/describeservices/",
    SNS_TOPIC = aws_sns_topic.getattributevalues.arn
  }
  
  allowed_triggers = {
    event_rule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.describeservices.arn
    }
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Trigger

resource "aws_cloudwatch_event_rule" "describeservices" {

  name                = "${var.application_name}-event-rule-weekly-describeservices"
  description         = "Run at 6pm UTC on the first of each month"
  schedule_expression = "cron(0 18 1 * ? *)" 
  tags                = var.common_tags

}

resource "aws_cloudwatch_event_target" "describeservices" {

  rule = aws_cloudwatch_event_rule.describeservices.name
  arn  = module.lambda_function_describeservices.lambda_function_arn

}
