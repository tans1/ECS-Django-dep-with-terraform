output "cluster-id" {
  value = aws_ecs_cluster.ecs_cluster.id
}


output "ecs_cluster" {
  value = aws_ecs_cluster.ecs_cluster
}

output "namespace" {
  value = aws_service_discovery_private_dns_namespace.backend_namespace.name
}