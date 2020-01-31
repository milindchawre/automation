module "ci_cd_ec2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "ci-cd-machine"
  instance_count         = 1

  ami                    = "ami-04763b3055de4860b"
  instance_type          = "t3.medium"
  key_name               = "test-us-east-1"
  vpc_security_group_ids = ["${module.ci_cd_sg.this_security_group_id}"]
  subnet_id              = "${module.vpc.public_subnets[0]}"
  associate_public_ip_address = true
  use_num_suffix = false
  user_data_base64 = "${base64encode(file("ubuntu_user_data_installer"))}"

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "ci-cd-machine"
  }

  volume_tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "ci-cd-machine"
  }
}

module "web_server_ec2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "web-server"
  instance_count         = 1

  ami                    = "ami-04763b3055de4860b"
  instance_type          = "t3.medium"
  key_name               = "test-us-east-1"
  vpc_security_group_ids = ["${module.ci_cd_sg.this_security_group_id}"]
  subnet_id              = "${module.vpc.private_subnets[0]}"
  use_num_suffix = true
  user_data_base64 = "${base64encode(file("ubuntu_user_data_web_server"))}"

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "web-server"
  }

  volume_tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "web-server"
  }
}
