# provider variables
variable "profile" {
  description = "aws iam profile name"
  type        = string
}

variable "aws_region" {
  description = "AWS region name"
  type        = string
}

# vpc variables

variable "vpc_name" {
  description = "AWS VPC name"
  type        = string
}

variable "azs" {
  description = "availability zones"
  type        = list(string)
}


variable "tags" {
  type = object({
    Environment = string
    CreatedBy   = string
    Project     = string
  })

}

# auto-sclaing group
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



# capacity providers
variable "cluster_name" {
  description = "Cluster name"
  type        = string

}

variable "capacity_provider" {
  type = string
}

# ec2 instance

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
  type    = string
  default = "t3.micro"
}



# loadbalancer

variable "ssl_certificate_arn" {
  type        = string
  description = "the ssl certificate from certificate manager"
}

variable "ssl-policy" {
  type = string
}

variable "main_domain" {
  type = string
}

variable "jenkins_webhook_domain" {
  type = string
}

variable "jenkins_image_url" {
  type = string
}

variable "jenkins_agent_ssh_pubkey" {
  type = string
}

# security group
variable "security_group_name" {
  type    = string
  default = "ecs-security-group"
}




# services
variable "django-image" {
  type = string
}

variable "nginx-image" {
  type = string
}
