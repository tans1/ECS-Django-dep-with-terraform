resource "aws_ecs_task_definition" "ecs_nginx_task_definition" {
  family       = "nginx-task"
  network_mode = "awsvpc"
  cpu          = 512
  memory       = 1024
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = var.image-address
      cpu       = 512
      memory    = 1024
      essential = true
      command   = ["nginx", "-g", "daemon off;"]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          name = "nginx-port"
        },
        # {
        #   containerPort = 443
        #   hostPort      = 443
        #   protocol      = "tcp"
        # }
      ]

      mountPoints = [
        {
          sourceVolume  = "nginx-storage"
          containerPath = "/mnt/data"
          configuredAtLaunch= true
        }
      ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/nginx-container"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
    }
  ])

  volume {
    name      = "nginx-storage"
    host_path = "/ecs/nginx-storage"
  }

  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

}

resource "aws_cloudwatch_log_group" "ecs_nginx_container_log_group" {
  name              = "/ecs/nginx-container"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "ecs_nginx_log_stream" {
  log_group_name = aws_cloudwatch_log_group.ecs_nginx_container_log_group.name
  name           = "ecs-nginx-log-stream"
}