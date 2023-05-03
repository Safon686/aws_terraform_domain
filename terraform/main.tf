#++++++++++++++++++++++++++++++++++++++++++++++++++++


#group for instance -> alb
resource "aws_security_group" "in_sec" {
  name   = "security_group_for_instance"
  vpc_id = aws_vpc.main.id
  dynamic "ingress" {
    for_each = ["80", "8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#====================================================
#group for alb
resource "aws_security_group" "web_my_sec" {
  name   = "domain_security_proup"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = ["443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#====================================================
resource "aws_launch_template" "web" {
  name_prefix   = "web-alt-"
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  user_data     = filebase64("user_data.sh")
  iam_instance_profile {
  name = aws_iam_instance_profile.s3_readonly.name
  }

  lifecycle {
    create_before_destroy = true
  }
  vpc_security_group_ids = [aws_security_group.in_sec.id]
}
#====================================================
#конфиг template для использования нескольких template с разными asg
/*
resource "aws_launch_template" "app" {
  name_prefix   = "web-alt-"
  image_id      = "ami-0ec7f9846da6b0f61"
  instance_type = "t2.micro"
  user_data     = filebase64("user_data_docker2.sh")
  lifecycle {
    create_before_destroy = true
  }
  vpc_security_group_ids = [aws_security_group.in_sec.id]
}
*/
#====================================================
resource "aws_autoscaling_group" "web-asg1" {
  vpc_zone_identifier       = [aws_subnet.my_subnet_az1.id, aws_subnet.my_subnet_az2.id]
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"

  }
  target_group_arns = [aws_lb_target_group.first.arn, aws_lb_target_group.second.arn]
}
#====================================================
#конфиг asg для использования нескольких template с разными asg
/*
resource "aws_autoscaling_group" "web-asg2" {
  vpc_zone_identifier = [aws_subnet.my_subnet_az1.id, aws_subnet.my_subnet_az2.id]
  min_size            = 1
  max_size            = 1
  health_check_grace_period = 300

  health_check_type   = "ELB"
  launch_template {
    id      = aws_launch_template.app.id
        version = "$Latest"

  }
    target_group_arns   = [aws_lb_target_group.second.arn]
}
*/
