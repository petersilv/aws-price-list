# ----------------------------------------------------------------------------------------------------------------------
# Locals

locals {

  application = "aws-price-list"
  application_one_word = "awspricelist"

  common_tags = {
    created_by  = "Terraform"
    application = local.application
    owner       = "Peter Silvester" 
  }

}

# ----------------------------------------------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

locals {

  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_caller_arn  = data.aws_caller_identity.current.arn
  aws_caller_user = data.aws_caller_identity.current.user_id

}