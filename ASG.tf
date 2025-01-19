data "template_file" "user_data" {
  vars = {
    db_endpoint = aws_db_instance.rds_instance.endpoint
    db_name     = aws_db_instance.rds_instance.db_name
    db_user     = aws_db_instance.rds_instance.username
    db_password = aws_db_instance.rds_instance.password
  }
  template = file("./user-data.sh")

}

data "template_file" "nginx_user_data" {

  template = file("./nginx-user-data.sh")

  vars = {
    nlb_dns_name = aws_lb.nlb.dns_name
    alb_dns_name = aws_lb.alb.dns_name
  }

}


resource "aws_launch_template" "app_instance" {
  name          = "app-instance"
  image_id      = var.app_ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.kp-1.key_name
  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  lifecycle {
    create_before_destroy = true
  }


}

resource "aws_launch_template" "nginx_srv" {
  name          = "nginx-instance"
  image_id      = var.nginx_ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.kp-1.key_name
  network_interfaces {
    security_groups = [aws_security_group.nginx_sg.id]
  }

  user_data = base64encode(data.template_file.nginx_user_data.rendered)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nginx_asg" {

  launch_template {
    id      = aws_launch_template.nginx_srv.id
    version = "$Latest"

  }
  vpc_zone_identifier = [aws_subnet.vpc_3_private_subnet_1.id, aws_subnet.vpc_3_private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.nlb_to_nginx.arn]
  min_size            = 1
  max_size            = 2
  desired_capacity    = 2

  tag {
    key                 = "Name"
    value               = "nginx-instance"
    propagate_at_launch = true
  }

}


resource "aws_autoscaling_group" "app_asg" {

  launch_template {
    id      = aws_launch_template.app_instance.id
    version = "$Latest"

  }

  vpc_zone_identifier = [aws_subnet.vpc_1_private_subnet_1.id, aws_subnet.vpc_1_private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.alb_to_ec2.arn]
  min_size            = 1
  max_size            = 2
  desired_capacity    = 2

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }

}
