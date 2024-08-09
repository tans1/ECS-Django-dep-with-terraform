resource "aws_ecs_service" "ecs_django_service" {
  name            = "django-service"
  cluster         = var.cluster-id
  task_definition = aws_ecs_task_definition.ecs_django_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private-subnets
    security_groups = [var.security-group-id]
  }

  // Redeploy Service On Every Apply, which  important for CICD
  force_new_deployment = true
  triggers = {
    redeployment = plantimestamp()
  }

  capacity_provider_strategy {
    capacity_provider = var.ec2-provider-name
    weight = 100
  }


  service_connect_configuration {
    enabled   = true
    namespace = var.namespace
    

    service {
      port_name = "django-port"
      client_alias {
        port     = 8080
        dns_name = "django"
      }
    }
  }
}