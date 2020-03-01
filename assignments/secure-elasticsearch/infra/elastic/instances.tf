module "elastic-ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "elasticsearch"
  instance_count = 1

  ami                         = "ami-02eac2c0129f6376b"
  instance_type               = "t3.medium"
  key_name                    = "test-us-east-1"
  vpc_security_group_ids      = [module.elastic_sg.this_security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  use_num_suffix              = false
  user_data_base64            = base64encode(file("elastic_user_data"))
  iam_instance_profile        = "elastic_role"

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 10
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/xvdf"
      volume_type = "gp2"
      volume_size = 5
      encrypted   = false
    },
    {
      device_name = "/dev/xvdg"
      volume_type = "gp2"
      volume_size = 5
      encrypted   = false
    },
    {
      device_name = "/dev/xvdh"
      volume_type = "gp2"
      volume_size = 5
      encrypted   = false
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "Dev"
    Name        = "elastic-ec2"
  }

  volume_tags = {
    Terraform   = "true"
    Environment = "Dev"
    Name        = "elastic-ec2"
  }
}

