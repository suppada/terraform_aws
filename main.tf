// Provider specific configs
module "my_ec2" {
  source              = "git::https://github.com/suppada/terraform.git//modules/ec2"
  ec2_count           = "2"
  ami_id              = "ami-0b0af3577fe5e3532"
  instance_type       = "t2.micro"
  key_name            = "suresh"
  role_name           = "java-test"
  user_data           = file("install.sh")
  security_group_name = "java-test"
  instance_profile    = "java-test"
  role_policy         = "java-test1"
  aws_region          = "us-east-2"
  subnet_id           = "subnet-06909708"
  environment_tag     = "qa"
  instance_name       = "Ansible"
  owner               = "suresh"
  project             = "Automation"
}
