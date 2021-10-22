# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

module "lambda_function_getproductstrigger" {

  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.application_name}-getproductstrigger"
  description   = "Read the Get Products lookup and trigger the Get Products function"
  tags          = var.common_tags
  handler       = "get_products_trigger.main"
  runtime       = "python3.7"
  memory_size   = 512
  timeout       = 60
  publish       = true

  create_role   = false
  lambda_role   = aws_iam_role.lambda_role.arn

  create_package         = false
  local_existing_package = "../lambda/get_products_trigger.zip"

  environment_variables = {
    S3_BUCKET = var.aws_s3_bucket_id,
    S3_PREFIX = "data/lookup/",
    S3_FILENAME = "get_products.json"
    SNS_TOPIC = aws_sns_topic.getproducts.arn
  }
  
  allowed_triggers = {
    event_rule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.getproductstrigger.arn
    }
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Trigger

resource "aws_cloudwatch_event_rule" "getproductstrigger" {

  name                = "${var.application_name}-event-rule-weekly-getproductstrigger"
  description         = "Run at 7pm UTC on the first of each month"
  schedule_expression = "cron(0 19 1 * ? *)" 
  tags                = var.common_tags

}

resource "aws_cloudwatch_event_target" "getproductstrigger" {

  rule = aws_cloudwatch_event_rule.getproductstrigger.name
  arn  = module.lambda_function_getproductstrigger.lambda_function_arn

}
