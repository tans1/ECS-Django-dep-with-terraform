variable "asg_desired_capacity" {
  description = "auto scaling group desired instance capacity"
  type        = number
}

variable "asg_max_size" {
  description = "auto scaling group max instance capacity"
  type        = number
}

variable "asg_min_size" {
  description = "auto scaling group min instance capacity"
  type        = number
}

variable "private-subnets" {
  type = list(string)
}

variable "launch_template_id" {
  type = string
}