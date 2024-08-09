resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name = "/aws/ec2/golang_react_instance"
  retention_in_days = 7
}


