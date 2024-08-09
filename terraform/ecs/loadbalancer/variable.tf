variable "ssl-policy" {
  type    = string
}

variable "ssl-certificate-arn" {
  type = string
}


variable "main_domain" {
  type = string
}

variable "jenkins_webhook_domain" {
  type = string
}

variable "security-group-id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}