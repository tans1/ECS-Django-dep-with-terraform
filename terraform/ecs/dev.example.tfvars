profile = "profile"

aws_region = "eu-north-1"

azs = ["eu-north-1a", "eu-north-1b"]

vpc_name = "myvpc"

cluster_name = ""




tags = {
  Environment = "dev"
  CreatedBy   = "terraform"
  Project     = "django-ecs"
}


asg_desired_capacity = 3
asg_max_size         = 5
asg_min_size         = 1





capacity_provider = ""

key_name = "generated_key_name"


ami_image_id        = "ami"
ecs_instance_prefix = ""
instance_type       = ""


ssl_certificate_arn = ""
ssl-policy          = ""
security_group_name = ""




django-image      = ""
nginx-image       = ""
jenkins_image_url = ""

main_domain            = ""
jenkins_webhook_domain = ""

jenkins_agent_ssh_pubkey = ""