resource "aws_ami_from_instance" "CPUtest-ami" {
     name                           = "CPUtest-ami"
      source_instance_id            = aws_instance.CPUtest.id
      depends_on                    = [ aws_instance.CPUtest ]
  }
resource "aws_launch_template" "launch-template" {
  name                              = "CPUtest-launch-template"
  image_id                          = aws_ami_from_instance.CPUtest-ami.id
  instance_type                     = "t2.micro"
  vpc_security_group_ids            = [data.aws_security_groups.my-sg.ids[0]]
  tag_specifications {
        resource_type   = "instance"
          tags          = {
            Name        = "autoCPUtest"
   }
  }
}
resource "aws_autoscaling_group" "auto-scaling-grp" {
  name                              = "my-autoscaling-group"
  max_size                          = 4
  min_size                          = 2
  desired_capacity                  = 2
  vpc_zone_identifier               = [data.aws_subnet.private_sub_1.id, data.aws_subnet.private_sub_2.id]
  target_group_arns                 = [aws_lb_target_group.target-group.arn]
  health_check_type                 = "ELB"
  health_check_grace_period         = 300
  launch_template {
    id                  = aws_launch_template.launch-template.id
    version             = "$Latest"
  }
}
resource "aws_autoscaling_policy" "policy" {
  name                              = "CPUpolicy"
  policy_type                       = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type        = "ASGAverageCPUUtilization"
    }
      target_value                  = 40.0
  }
  autoscaling_group_name            = aws_autoscaling_group.auto-scaling-grp.name
}