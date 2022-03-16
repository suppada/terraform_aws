// Provider specific configs
module "my_ec2" {
  source              = "git::https://github.com/suppada/terraform.git//modules/ec2"
  ec2_count           = "2"
  ami_id              = "ami-0b0af3577fe5e3532"
  instance_type       = "t2.micro"
  key_name            = "suresh"
  role_name           = "test-java"
  user_data           = file("user-ansible.sh")
  security_group_name = "test-java"
  instance_profile    = "test-java"
  role_policy         = "test-java"
  aws_region          = "us-east-1"
  subnet_id           = "subnet-06909708"
  environment_tag     = "dev"
  instance_name       = "Ansible"
  owner               = "suresh"
  project             = "Automation"
}