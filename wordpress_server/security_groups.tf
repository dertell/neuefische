resource "aws_security_group" "my_vpc_sg_allow_http"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "my_vpc_allow_http"
        tags = {
            Name = "my_vpc_sg_allow_http"
        }
    }
    resource "aws_security_group_rule" "http_ingress_access"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.my_vpc_sg_allow_http.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_block]
    }
    resource "aws_security_group_rule" "https_egress_access"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.my_vpc_sg_allow_http.id
        to_port                     = 0
        type                        = "egress"
        cidr_blocks                 = [var.cidr_block]
    }
resource "aws_security_group" "autoscaling-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "autoscaling-sg"
        tags = {
            Name = "autoscaling rule"
        }
    }
    resource "aws_security_group_rule" "autoscaling-sg-in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_block]
    }
    resource "aws_security_group_rule" "autoscaling-sg-out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = [var.cidr_block]
    }
resource "aws_security_group" "alb-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "alb-sg"
        tags = {
            Name = "alb-sg"
        }
    }
    resource "aws_security_group_rule" "alb-sg-http-in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.alb-sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_block]
    }
    resource "aws_security_group_rule" "alb-sg-tcp-out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.alb-sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = [var.cidr_block]
    }
  