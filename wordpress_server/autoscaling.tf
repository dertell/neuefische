resource "aws_launch_template" "launch-template" {
  name                              = "webserver-launch-template"
  image_id                          = data.aws_ami.amzLinux.id
  instance_type                     = "t2.micro"
  vpc_security_group_ids            = [aws_security_group.autoscaling-sg.id]
  user_data                         = base64encode(templatefile("new-user-data.sh",{
        DB      = local.DB
        User    = local.User
        PW      = local.PW
        host    = local.host
    }))
      depends_on = [ aws_db_instance.mysql-db ]
  tag_specifications {
        resource_type = "instance"
        tags          = {
            Name      = "wp-server"
   }
  }
}
resource "aws_autoscaling_group" "auto-scaling-grp" {
  name                              = "my-autoscaling-group"
  max_size                          = 4
  min_size                          = 2
  desired_capacity                  = 2
  vpc_zone_identifier               = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  target_group_arns                 = [aws_lb_target_group.target-group.arn]
  health_check_type                 = "ELB"
  health_check_grace_period         = 300
  launch_template {
    id                = aws_launch_template.launch-template.id
    version           = "$Latest"
  }
}
resource "aws_autoscaling_policy" "policy" {
  name                              = "CPUpolicy"
  policy_type                       = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type        = "ASGAverageCPUUtilization"
    }
      target_value                  = 75.0
  }
  autoscaling_group_name            = aws_autoscaling_group.auto-scaling-grp.name
}
