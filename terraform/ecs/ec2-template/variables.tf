variable "key_name" {
  type = string
}

variable "ami_image_id" {
  type        = string
  description = "ami image id to launch the instance"
}

variable "ecs_instance_prefix" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string

}

variable "security-group-id" {
  type = string
}

variable "ec2_instance_profile_name" {
  type = string
}