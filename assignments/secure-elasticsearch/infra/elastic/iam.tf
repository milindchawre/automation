resource "aws_iam_role" "elastic_role" {
  name               = "elastic_role"
  description        = "IAM role for elastic"
  assume_role_policy = file("assumerolepolicy.json")
}

resource "aws_iam_policy" "elastic_ec2_vol_policy" {
  name        = "elastic-ec2-describe-volume"
  description = "EC2 describe volume policy for elastic"
  policy      = file("ec2-describe-volume-policy.json")
}

resource "aws_iam_policy_attachment" "elastic-ec2-policy-attach" {
  name       = "elastic-ec2-policy-attach"
  roles      = [aws_iam_role.elastic_role.name]
  policy_arn = aws_iam_policy.elastic_ec2_vol_policy.arn
}

resource "aws_iam_instance_profile" "elastic_profile" {
  name = "elastic_role"
  role = aws_iam_role.elastic_role.name
}

