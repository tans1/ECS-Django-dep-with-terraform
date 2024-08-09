resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = var.capacity_provider

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.auto_scaling_group_arn
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 75
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  cluster_name = var.cluster_name

  capacity_providers = [var.capacity_provider]

  default_capacity_provider_strategy {
    base              = 1
    capacity_provider = var.capacity_provider
  }
  depends_on = [ aws_ecs_capacity_provider.ecs_capacity_provider, var.ecs_cluster ]
}