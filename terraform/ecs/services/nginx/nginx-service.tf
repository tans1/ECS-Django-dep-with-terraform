resource "aws_ecs_service" "ecs_nginx_service" {
  name            = "nginx-service"
  cluster         = var.cluster-id
  task_definition = aws_ecs_task_definition.ecs_nginx_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.security-group-id]
  }

  force_new_deployment = true
  triggers = {
    redeployment = plantimestamp()
  }

  capacity_provider_strategy {
    capacity_provider = var.ec2-provider-name
    weight = 100
  }

  load_balancer {
    target_group_arn = var.load_balancer_arn
    container_name   = "nginx"
    container_port   = 80
  }


  # load_balancer {
  # 	target_group_arn = local.load-balancer-arn
  # 	container_name   = "nginx"
  # 	container_port   = 443
  # }

  service_connect_configuration {
    enabled   = true
    namespace = var.namespace
    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group         = "/ecs/django-container"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }

  depends_on = [ var.loadbalancer, var.loadbalancer_target_group ]
}