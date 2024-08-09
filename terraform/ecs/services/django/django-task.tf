resource "aws_ecs_task_definition" "ecs_django_task_definition" {
  family       = "django-task"
  network_mode = "awsvpc"
  cpu          = 512
  memory       = 1024

  container_definitions = jsonencode([
    {
      name      = "django"
      image     = var.image-address
      cpu       = 512
      memory    = 1024
      essential = true
      command   = ["uwsgi", "--ini", "uwsgi.ini"]
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
          name = "django-port"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "django-storage"
          containerPath = "/mnt/data"
        }
      ]
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/django-container"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
    }
  ])

  volume {
    name      = "django-storage"
    host_path = "/ecs/django-storage"
  }


  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  depends_on = [ aws_cloudwatch_log_group.ecs_django_container_log_group ]
}


resource "aws_cloudwatch_log_group" "ecs_django_container_log_group" {
  name              = "/ecs/django-container"
  retention_in_days = 7 
}
resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  log_group_name = aws_cloudwatch_log_group.ecs_django_container_log_group.name
  name           = "ecs-django-container-log-stream"
}