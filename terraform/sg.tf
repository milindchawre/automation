module "ci_cd_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ci-cd-machine-sg"
  description = "Security group for ci-cd-machine"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_with_self        = [{rule = "all-all"}]
  egress_rules             = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "tcp port 8080"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      description = "ssh port 22"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
