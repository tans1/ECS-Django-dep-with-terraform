resource "aws_lb" "loadbalancer" {
  name               = "alb-tof-ecs-2024"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security-group-id]
  subnets            = var.public_subnets

  tags = {
    Name = "alb-tof-ecs-2024"
  }
}

resource "aws_lb_target_group" "ecs_tg_http" {
  name        = "ecs-target-group-http"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }
}

# resource "aws_lb_target_group" "ecs_tg_https" { 
#   name        = "ecs-target-group-https"
#   port        = 443
#   protocol    = "HTTPS"
#   target_type = "ip"
#   vpc_id      = module.vpc.vpc_id

#   health_check {
#     path = "/"
#   }
# }


resource "aws_lb_listener" "loadbalancer_http_listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "loadbalancer_https_listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = var.ssl-policy
  certificate_arn = var.ssl-certificate-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg_http.arn
  }
}
