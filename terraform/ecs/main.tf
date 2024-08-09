module "vpc" {
  source = "./vpc"

  vpc_name            = var.vpc_name
  azs                 = var.azs
  security_group_name = var.security_group_name
  tags                = var.tags
}


module "django-service" {
  source                      = "./services/django"
  image-address               = var.django-image
  cluster-id                  = module.ecs-cluster.cluster-id
  private-subnets             = module.vpc.private-subnets
  security-group-id           = module.security-group.security-group-id
  ec2-provider-name           = module.capacity-provider.ec2-provider-name
  ecs_task_execution_role_arn = module.Iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.Iam.ecs_task_role_arn
  namespace                   = module.ecs-cluster.namespace
  aws_region                  = var.aws_region
}

module "nginx-service" {
  source                      = "./services/nginx"
  image-address               = var.nginx-image
  load_balancer_arn           = module.load_balancer.arn
  cluster-id                  = module.ecs-cluster.cluster-id
  private_subnets             = module.vpc.private-subnets
  security-group-id           = module.security-group.security-group-id
  ec2-provider-name           = module.capacity-provider.ec2-provider-name
  ecs_task_execution_role_arn = module.Iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.Iam.ecs_task_role_arn
  namespace                   = module.ecs-cluster.namespace
  aws_region                  = var.aws_region

  loadbalancer              = module.load_balancer.loadbalancer
  loadbalancer_target_group = module.load_balancer.loadbalancer_target_group
}

module "jenkins-service" {
  source                      = "./services/jenkins"
  jenkins_image_url           = var.jenkins_image_url
  jenkins_agent_ssh_pubkey    = var.jenkins_agent_ssh_pubkey
  cluster-id                  = module.ecs-cluster.cluster-id
  private_subnets             = module.vpc.private-subnets
  security-group-id           = module.security-group.security-group-id
  ec2-provider-name           = module.capacity-provider.ec2-provider-name
  ecs_task_execution_role_arn = module.Iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.Iam.ecs_task_role_arn
  namespace                   = module.ecs-cluster.namespace
  aws_region                  = var.aws_region

}
module "ecs-cluster" {
  source       = "./ecs"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
}

module "capacity-provider" {
  source                 = "./capacity-providers"
  cluster_name           = var.cluster_name
  capacity_provider      = var.capacity_provider
  auto_scaling_group_arn = module.auto-scaling.auto_scaling_group_arn
  ecs_cluster            = module.ecs-cluster.ecs_cluster
}

module "security-group" {
  source              = "./security-group"
  security_group_name = var.security_group_name
  vpc_id              = module.vpc.vpc_id
  vpc_cidr_block      = module.vpc.vpc_cidr_block
}

module "load_balancer" {
  source                 = "./loadbalancer"
  ssl-policy             = var.ssl-policy
  ssl-certificate-arn    = var.ssl_certificate_arn
  main_domain            = var.main_domain
  jenkins_webhook_domain = var.jenkins_webhook_domain
  security-group-id      = module.security-group.security-group-id
  public_subnets         = module.vpc.public-subnets
  vpc_id                 = module.vpc.vpc_id
}

module "auto-scaling" {
  source               = "./autoscaling-group"
  asg_desired_capacity = var.asg_desired_capacity
  asg_max_size         = var.asg_max_size
  asg_min_size         = var.asg_min_size
  private-subnets      = module.vpc.private-subnets
  launch_template_id   = module.ec2-template.launch_template_id

}

module "Iam" {
  source = "./Iam"

}
module "ec2-template" {
  source              = "./ec2-template"
  key_name            = var.key_name
  cluster_name        = var.cluster_name
  instance_type       = var.instance_type
  ecs_instance_prefix = var.ecs_instance_prefix
  ami_image_id        = var.ami_image_id
  security-group-id   = module.security-group.security-group-id
  ec2_instance_profile_name = module.Iam.ec2_instance_profile_name
}