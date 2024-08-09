output "public-subnets" {
  value = module.vpc.public_subnets
}
output "private-subnets" {
  value = module.vpc.private_subnets

}
output "vpc_id" {
  value = module.vpc.vpc_id

}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block

}