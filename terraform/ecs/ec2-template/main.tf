resource "tls_private_key" "pri_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.pri_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
		echo '${tls_private_key.pri_key.private_key_pem}' > ./'${var.key_name}'.pem
		chmod 400 ./'${var.key_name}'.pem
	EOT
  }

}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = var.ecs_instance_prefix
  image_id      = var.ami_image_id
  instance_type = var.instance_type

  key_name               = var.key_name
  vpc_security_group_ids = [var.security-group-id]

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", { cluster_name = var.cluster_name }))
}


