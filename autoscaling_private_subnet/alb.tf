resource "aws_lb" "load-balancer" {
  name                              = "Webserver-alb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = [data.aws_security_groups.my-sg.ids[0]]
  subnets                           = [data.aws_subnet.public_sub_1.id, data.aws_subnet.public_sub_2.id]
  enable_deletion_protection        = false
  enable_http2                      = true
    tags = {
        Environment                 = "production"
  }
}
resource "aws_lb_target_group" "target-group" {
  name                              = "webserver-tg"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = data.aws_vpc.my_vpc.id
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