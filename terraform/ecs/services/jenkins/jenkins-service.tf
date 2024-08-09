resource "aws_ecs_service" "jenkins" {
  name            = "jenkins-service"
  cluster         = var.cluster-id
  task_definition = aws_ecs_task_definition.jenkins.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.security-group-id]
  }

  capacity_provider_strategy {
    capacity_provider = var.ec2-provider-name
    weight            = 100
  }

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

    service {
      port_name = "jenkins-port"
      client_alias {
        port     = 8080
        dns_name = "jenkins"
      }
    }
  }

}
