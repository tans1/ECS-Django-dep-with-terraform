variable "capacity_provider" {
  type    = string

}

variable "cluster_name" {
  description = "Cluster name"
  type        = string

}

variable "auto_scaling_group_arn" {
  type = string
}


variable "ecs_cluster" {
  type = any
}