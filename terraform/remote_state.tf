terraform {
  backend "s3" {}
}

/*
data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    encrypt = true
    bucket = "terrastate2020"
    dynamodb_table = "terraform-lock-dynamo"
    region = "us-east-1"
    key = "test/terraform.tfstate"
  }
}
*/
