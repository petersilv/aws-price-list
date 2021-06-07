# ----------------------------------------------------------------------------------------------------------------------
# Locals

locals {

  application = "aws-price-list"

  common_tags = {
    created_by  = "terraform"
    application = local.application
  }

}

# ----------------------------------------------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

locals {

  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_caller_arn  = data.aws_caller_identity.current.arn
  aws_caller_user = data.aws_caller_identity.current.user_id

}