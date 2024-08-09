output "arn" {
  value = aws_lb_target_group.ecs_tg_http.arn
}

output "loadbalancer" {
  value = aws_lb.loadbalancer
}

output "loadbalancer_target_group" {
  value = aws_lb_target_group.ecs_tg_http
}