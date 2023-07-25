resource "aws_lb" "load-balancer" {
  name                              = "Webserver-alb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = [aws_security_group.alb-sg.id]
  subnets                           = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  enable_deletion_protection        = false
    tags = {
        Environment                 = "production"
  }
}
resource "aws_lb_target_group" "target-group" {
  name                              = "CPUtest-tg"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = aws_vpc.my_vpc.id
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn                 = aws_lb.load-balancer.arn
  port                              = "80"
  protocol                          = "HTTP"
  default_action {
    type                            = "forward"
    target_group_arn                = aws_lb_target_group.target-group.arn
  }
}

resource "aws_lb_listener_rule" "wordpress-rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-wordpress.arn
  }
  condition {
    path_pattern {
      values = ["/wordpress/"]
    }
  }
}
resource "aws_lb_target_group" "target-group-wordpress" {
  name                              = "webserver-tg"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = aws_vpc.my_vpc.id
  health_check {
    path = "/wordpress/"
  }
}
resource "aws_lb_target_group_attachment" "wordpress" {
  target_group_arn = aws_lb_target_group.target-group-wordpress.arn
  target_id        = aws_instance.webserver.id
  port             = 80
}