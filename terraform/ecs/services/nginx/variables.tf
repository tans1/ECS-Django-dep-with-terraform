variable "image-address" {
  type = string
}

variable "cluster-id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "security-group-id" {
  type = string
}

variable "ec2-provider-name" {
  type = string
}


variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "load_balancer_arn" {
  type = string
}

variable "namespace" {
  type = string
  
}

variable "aws_region" {
  type = string
}

variable "loadbalancer" {
  type = any
}

variable "loadbalancer_target_group" {
  type = any
}