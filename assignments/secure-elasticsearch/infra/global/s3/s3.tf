resource "aws_s3_bucket" "state" {
  bucket = "elastic-terra-state-2020"
  acl    = "private"

  tags = {
    Name        = "terraform-state-bucket"
    Environment = "Dev"
  }
}

