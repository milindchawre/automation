module "elastic_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "elastic-sg"
  description = "Security group for elastic-ec2"
  version     = "~> v3.0"
  vpc_id      = module.vpc.vpc_id

  ingress_with_self = [{
    rule = "all-all"
  }]
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 9300
      to_port     = 9305
      protocol    = "tcp"
      description = "tcp port 9300-9305"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9200
      to_port     = 9200
      protocol    = "tcp"
      description = "tcp port 9200 for elasticsearch"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 5601
      to_port     = 5601
      protocol    = "tcp"
      description = "tcp port 5601 for kibana"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      description = "ssh port 22"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

