output "resource" {
  value = aws_autoscaling_group.ecs_asg
}


output "auto_scaling_group_arn" {
  value = aws_autoscaling_group.ecs_asg.arn
}