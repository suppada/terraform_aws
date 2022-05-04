// Provider specific configs
module "master" {
  source              = "git::https://github.com/suppada/terraform.git//modules/ec2"
  ec2_count           = "1"
  ami_id              = "ami-0b0af3577fe5e3532"
  instance_type       = "t2.micro"
  key_name            = "suresh"
  user_data           = file("install.sh")
  aws_region          = "us-east-1"
  subnet_id           = "subnet-06909708"
  environment_tag     = "Dev"
  instance_name       = "test"
  project             = "Devops"
  owner               = "suresh"
  role_name           = "dev"
  role_policy         = "dev"
  security_group_name = "dev"
  volume_size         = "30"
  instance_profile    = "dev"
}