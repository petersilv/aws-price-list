# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

module "lambda_function_getproducts" {

  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.application_name}-getproducts"
  description   = "Call the Get Products Endpoint and write results to S3"
  tags          = var.common_tags
  handler       = "get_products.main"
  runtime       = "python3.7"
  memory_size   = 2048
  timeout       = 600
  publish       = true

  create_role   = false
  lambda_role   = aws_iam_role.lambda_role.arn

  create_package         = false
  local_existing_package = "../lambda/get_products.zip"

  environment_variables = {
    S3_BUCKET = var.aws_s3_bucket_id,
    S3_PREFIX = "data/getproducts/",
  }
  
  allowed_triggers = {
    event_rule = {
      principal  = "sns.amazonaws.com"
      source_arn = aws_sns_topic.getproducts.arn
    }
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Trigger

resource "aws_sns_topic" "getproducts" {
  name = "${var.application_name}-getproducts"
}

resource "aws_sns_topic_subscription" "getproducts" {
  protocol  = "lambda"
  topic_arn = aws_sns_topic.getproducts.arn
  endpoint  = module.lambda_function_getproducts.lambda_function_arn
}