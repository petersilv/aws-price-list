# ----------------------------------------------------------------------------------------------------------------------
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# ----------------------------------------------------------------------------------------------------------------------
provider "snowflake" {
  authenticator = "SNOWFLAKE_JWT"

  organization_name = var.sno_organization_name
  account_name      = var.sno_account_name
  user              = var.sno_user

  private_key            = file(var.sno_private_key_path)
  private_key_passphrase = var.sno_private_key_passphrase
}
