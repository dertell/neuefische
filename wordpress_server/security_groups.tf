resource "aws_security_group" "bastion-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "bastion-sg"
        tags = {
            Name = "bastion-sg"
        }
    }
    resource "aws_vpc_security_group_ingress_rule" "bastion_ingress"{
        from_port                   = 22
        ip_protocol                    = "tcp"
        security_group_id           = aws_security_group.bastion-sg.id
        to_port                     = 22
        cidr_ipv4                   = var.cidr_block
    }
    resource "aws_vpc_security_group_egress_rule" "bastion_egress"{
        from_port                   = 0
        ip_protocol                    = "all"
        security_group_id           = aws_security_group.bastion-sg.id
        to_port                     = 0
        cidr_ipv4                   = var.cidr_block
    }
resource "aws_security_group" "autoscaling-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "autoscaling-sg"
        tags = {
            Name = "autoscaling-sg"
        }
    }
    resource "aws_vpc_security_group_ingress_rule" "autoscaling-ingress-http"{
        from_port                   = 80
        ip_protocol                    = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 80
        referenced_security_group_id=  aws_security_group.alb-sg.id
    }
    resource "aws_vpc_security_group_ingress_rule" "autoscaling-ingress-ssh"{
        from_port                   = 22
        ip_protocol                    = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 22
        referenced_security_group_id= aws_security_group.bastion-sg.id
    }
    resource "aws_vpc_security_group_egress_rule" "autoscaling-egress"{
        from_port                   = 0
        ip_protocol                    = "all"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 65535
        cidr_ipv4                   = var.cidr_block
    }
resource "aws_security_group" "alb-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "alb-sg"
        tags = {
            Name = "alb-sg"
        }
    }
    resource "aws_vpc_security_group_ingress_rule" "alb-sg-http-in"{
        from_port                   = 80
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.alb-sg.id
        to_port                     = 80
        cidr_ipv4                   = var.cidr_block
    }
    resource "aws_vpc_security_group_egress_rule" "alb-sg-out"{
        from_port                   = 80
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.alb-sg.id
        to_port                     = 80
        referenced_security_group_id = aws_security_group.autoscaling-sg.id
    }
  resource "aws_security_group" "wordpress-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "wordpress-sg"
        tags = {
            Name = "wordpress-sg"
        }
    }
    resource "aws_vpc_security_group_ingress_rule" "wordpress-sg-http-in"{
        from_port                   = 80
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.wordpress-sg.id
        to_port                     = 80
        cidr_ipv4                   = var.cidr_block
    }
    resource "aws_vpc_security_group_egress_rule" "wordpress-sg-out"{
        from_port                   = 80
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.wordpress-sg.id
        to_port                     = 80
        cidr_ipv4                   = var.cidr_block
    }