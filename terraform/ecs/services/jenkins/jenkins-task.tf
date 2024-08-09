resource "aws_ecs_task_definition" "jenkins" {
  family       = "jenkins-task"
  network_mode = "awsvpc"
  cpu          = 1536
  memory       = 1536

  container_definitions = jsonencode([
    // Docker:Dind
    {
      name       = "docker-dind"
      image      = "docker:dind"
      cpu        = 512
      memory     = 512
      essential  = true
      privileged = true
      environment = [
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = "/certs"
        }
      ]
      portMappings = [
        {
          containerPort = 2376
          hostPort      = 2376
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "jenkins-docker-certs"
          containerPath = "/certs/client"
        },
        {
          sourceVolume  = "jenkins-data"
          containerPath = "/var/jenkins_home"
        }
      ]
      command = ["--storage-driver", "overlay2"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/jenkins-dind"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    // the controller(master) node
    {
      name      = "jenkins"
      image     = var.jenkins_image_url
      cpu       = 512
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          name          = "jenkins-port"
        },
        {
          containerPort = 50000
          hostPort      = 50000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DOCKER_HOST"
          value = "tcp://docker:2376"
        },
        {
          name  = "DOCKER_CERT_PATH"
          value = "/certs/client"
        },
        {
          name  = "DOCKER_TLS_VERIFY"
          value = "1"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group        = "/ecs/jenkins"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      mountPoints = [
        {
          sourceVolume  = "jenkins-storage"
          containerPath = "/var/jenkins_home"
        },
        {
          sourceVolume  = "docker-socket"
          containerPath = "/certs/client:ro"
        }
      ]
    },

    // the agent(slave) node
    {
      name      = "jenkins-agent"
      image     = "jenkins/ssh-agent:alpine-jdk17"
      cpu       = 512
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 22
          hostPort      = 22
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "JENKINS_AGENT_SSH_PUBKEY"
          value = var.jenkins_agent_ssh_pubkey
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/jenkins-agent"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
  ])

  volume {
    name      = "jenkins-storage"
    host_path = "/var/jenkins/jenkins-data"
  }
  volume {
    name      = "docker-socket"
    host_path = "/var/jenkins/jenkins-docker-certs"
  }
  volume {
    name      = "jenkins-docker-certs"
    host_path = "/var/jenkins/jenkins-docker-certs"
  }

  volume {
    name      = "jenkins-data"
    host_path = "/var/jenkins/jenkins-data"
  }
  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  depends_on = [aws_cloudwatch_log_group.ecs_jenkins_agent_container_log_group, aws_cloudwatch_log_group.ecs_jenkins_container_log_group, aws_cloudwatch_log_group.ecs_jenkins_dind_container_log_group]
}


resource "aws_cloudwatch_log_group" "ecs_jenkins_container_log_group" {
  name              = "/ecs/jenkins"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "ecs_jenkins_container_log_stream" {
  log_group_name = aws_cloudwatch_log_group.ecs_jenkins_container_log_group.name
  name           = "ecs-jenkins-container-log-stream"
}

resource "aws_cloudwatch_log_group" "ecs_jenkins_agent_container_log_group" {
  name              = "/ecs/jenkins-agent"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "ecs_jenkins_agent_log_stream" {
  log_group_name = aws_cloudwatch_log_group.ecs_jenkins_agent_container_log_group.name
  name           = "ecs-jenkins-agent-log-stream"
}
resource "aws_cloudwatch_log_group" "ecs_jenkins_dind_container_log_group" {
  name              = "/ecs/jenkins-dind"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_stream" "ecs_jenkins_dind_log_stream" {
  log_group_name = aws_cloudwatch_log_group.ecs_jenkins_dind_container_log_group.name
  name           = "ecs-jenkins-dind-log-stream"
}