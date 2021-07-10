# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

module "lambda_function_getattributevalues" {

  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.application_one_word}-getattributevalues"
  description   = "Call the Get Attribute Values Endpoint and write Attribute Values to S3"
  tags          = var.common_tags
  handler       = "get_attribute_values.main"
  runtime       = "python3.7"
  memory_size   = 1024
  timeout       = 600
  publish       = true
  
  reserved_concurrent_executions = 2

  create_role   = false
  lambda_role   = aws_iam_role.lambda_role.arn

  create_package         = false
  local_existing_package = "../lambda/get_attribute_values.zip"

  environment_variables = {
    S3_BUCKET = var.aws_s3_bucket_id,
    S3_PREFIX = "data/getattributevalues/"
  }
  
  allowed_triggers = {
    event_rule = {
      principal  = "sns.amazonaws.com"
      source_arn = aws_sns_topic.getattributevalues.arn
    }
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Trigger

resource "aws_sns_topic" "getattributevalues" {
  name = "${var.application_one_word}-getattributevalues"
}

resource "aws_sns_topic_subscription" "getattributevalues" {
  protocol  = "lambda"
  topic_arn = aws_sns_topic.getattributevalues.arn
  endpoint  = module.lambda_function_getattributevalues.lambda_function_arn
}