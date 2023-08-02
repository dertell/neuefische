resource "aws_security_group" "bastion-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "bastion-sg"
        tags = {
            Name = "bastion-sg"
        }
    }
    resource "aws_vpc_security_group_ingress_rule" "bastion_ingress"{
        from_port                   = 22
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.bastion-sg.id
        to_port                     = 22
        cidr_ipv4                   = var.cidr_block
    }
    resource "aws_vpc_security_group_egress_rule" "bastion_egress"{
        from_port                   = 0
        ip_protocol                 = "tcp"
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
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 80
        cidr_ipv4                   = var.cidr_block
    }
    resource "aws_vpc_security_group_ingress_rule" "autoscaling-ingress-ssh"{
        from_port                   = 22
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 22
        referenced_security_group_id= aws_security_group.bastion-sg.id
    }
    resource "aws_vpc_security_group_ingress_rule" "autoscaling-ingress-mysql"{
        from_port                   = 3306
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 3306
        referenced_security_group_id= aws_security_group.mysqldb-sg.id
    }
    resource "aws_vpc_security_group_egress_rule" "autoscaling-http-egress"{
        from_port                   = 0
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 65535
        cidr_ipv4                   = var.cidr_block
    }
    resource "aws_vpc_security_group_egress_rule" "autoscaling-mysql-egress"{
        from_port                   = 3306
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 3306
        referenced_security_group_id= aws_security_group.mysqldb-sg.id
    }
    resource "aws_vpc_security_group_egress_rule" "autoscaling-https-egress"{
        from_port                   = 443
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.autoscaling-sg.id
        to_port                     = 443
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
    resource "aws_vpc_security_group_ingress_rule" "alb-sg-https-in"{
        from_port                   = 443
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.alb-sg.id
        to_port                     = 443
        cidr_ipv4                   = var.cidr_block
    }
    resource "aws_vpc_security_group_egress_rule" "alb-sg-out"{
        from_port                   = 80
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.alb-sg.id
        to_port                     = 80
        referenced_security_group_id = aws_security_group.autoscaling-sg.id
    }

resource "aws_security_group" "mysqldb-sg"{
        vpc_id                      = aws_vpc.my_vpc.id
        name                        = "mysqldb-sg"
        tags = {
            Name = "mysqldb-sg"
        }
    }
    resource "aws_vpc_security_group_ingress_rule" "mysqldb-ingress"{
        from_port                   = 3306
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.mysqldb-sg.id
        to_port                     = 3306
        referenced_security_group_id= aws_security_group.autoscaling-sg.id
    }
    resource "aws_vpc_security_group_ingress_rule" "mysqldb-bastion-ingress"{
        from_port                   = 3306
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.mysqldb-sg.id
        to_port                     = 3306
        referenced_security_group_id= aws_security_group.bastion-sg.id
    }

    resource "aws_vpc_security_group_egress_rule" "mysqldb-egress"{
        from_port                   = 3306
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.mysqldb-sg.id
        to_port                     = 3306
        referenced_security_group_id= aws_security_group.autoscaling-sg.id
    }
    resource "aws_vpc_security_group_egress_rule" "mysqldb-bastion-egress"{
        from_port                   = 3306
        ip_protocol                 = "tcp"
        security_group_id           = aws_security_group.mysqldb-sg.id
        to_port                     = 3306
        referenced_security_group_id= aws_security_group.bastion-sg.id
    }