variable "jenkins_image_url" {
  type = string
}

variable "jenkins_agent_ssh_pubkey" {
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

variable "namespace" {
  type = string

}

variable "aws_region" {
  type = string
}