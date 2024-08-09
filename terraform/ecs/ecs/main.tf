resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_service_discovery_private_dns_namespace" "backend_namespace" {
  name = "backend-namespace"
  vpc  = var.vpc_id
}
