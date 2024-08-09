variable "vpc_name" {
  description = "AWS VPC name"
  type        = string
}


variable "azs" {
  description = "availability zones"
  type        = list(string)
}

variable "security_group_name" {
  type    = string
  default = "ecs-security-group"
}


variable "tags" {
  type = object({
    Environment = string
    CreatedBy   = string
    Project     = string
  })

}