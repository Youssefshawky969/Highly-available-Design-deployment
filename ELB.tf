#  NLB in vpc 3

resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_sg.id]
  subnets            = [aws_subnet.vpc_3_public_subnet_1.id, aws_subnet.vpc_3_public_subnet_2.id]
}

#   NLB_target group
resource "aws_lb_target_group" "nlb_to_nginx" {
  name        = "nlb-to-nginx"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc_3.id
  target_type = "instance"

  health_check {
    port                = 80
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#   NLB Listener
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_to_nginx.arn
  }
}

#    ALB in vpc 1
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.vpc_1_private_subnet_1.id, aws_subnet.vpc_1_private_subnet_2.id]

}

# ALB target group
resource "aws_lb_target_group" "alb_to_ec2" {
  name        = "alb-to-ec2"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_1.id
  target_type = "instance"

  health_check {
    port                = 80
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#   ALB listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_to_ec2.arn
  }
}