#====================================================
resource "aws_lb" "web" {
        name               = "web-elb"
        internal           = false
        load_balancer_type = "application"
        security_groups    = [aws_security_group.web_my_sec.id, aws_security_group.in_sec.id]
        subnets            = [aws_subnet.my_subnet_az1.id, aws_subnet.my_subnet_az2.id]
}

#====================================================
resource "aws_lb_target_group" "first" {
  name        = "web"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  
  health_check {
    path = "/"
  }
}
#====================================================
resource "aws_lb_target_group" "second" {
  name        = "myapp"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  
  health_check {
    path = "/"
  }
}
#====================================================
resource "aws_lb_listener" "first" {
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:eu-central-1:719373697694:certificate/03e90d2c-3844-483f-88d8-08604ca15c64"
  default_action {
    target_group_arn = aws_lb_target_group.first.arn
    type             = "forward"
  }
}
#====================================================
resource "aws_lb_listener_rule" "myapp" {
  listener_arn = aws_lb_listener.first.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.second.arn
  }
  condition {
    host_header {
      values = ["myapp.safon686.com"]
    }
  }
}

#====================================================
resource "aws_autoscaling_attachment" "web1" {
  autoscaling_group_name = aws_autoscaling_group.web-asg1.name
  lb_target_group_arn   = aws_lb_target_group.first.arn
}
#====================================================
resource "aws_autoscaling_attachment" "web2" {
  autoscaling_group_name = aws_autoscaling_group.web-asg1.name
  lb_target_group_arn   = aws_lb_target_group.second.arn
}

#====================================================