
    provider "aws" {
        region                      = var.region
    }
    data "aws_availability_zones" "my_vpc_available"{}
    resource "aws_vpc" "my_vpc" {
        cidr_block                  = "10.0.0.0/16"
        enable_dns_hostnames        = true
        enable_dns_support          = true
        tags = {
            Name = "friday_chall_vpc"
        }
    }
    resource "aws_subnet" "public_subnet_1" {
        cidr_block                  = "10.0.1.0/24"
        vpc_id                      = aws_vpc.my_vpc.id
        map_public_ip_on_launch     = true
        availability_zone           = data.aws_availability_zones.my_vpc_available.names[0]
        tags = {
            Name = "public_subnet_1"
        }
    }
    resource "aws_subnet" "private_subnet_1" {
        cidr_block                  = "10.0.2.0/24"
        vpc_id                      = aws_vpc.my_vpc.id
        map_public_ip_on_launch     = false
        availability_zone           = data.aws_availability_zones.my_vpc_available.names[0]
        tags = {
            Name = "private_subnet_1"
        }
    }
    resource "aws_subnet" "public_subnet_2" {
        cidr_block                  = "10.0.3.0/24"
        vpc_id                      = aws_vpc.my_vpc.id
        map_public_ip_on_launch     = true
        availability_zone           = data.aws_availability_zones.my_vpc_available.names[1]
        tags = {
            Name = "public_subnet_2"
        }
    }
    resource "aws_subnet" "private_subnet_2" {
        cidr_block                  = "10.0.4.0/24"
        vpc_id                      = aws_vpc.my_vpc.id
        map_public_ip_on_launch     = false
        availability_zone           = data.aws_availability_zones.my_vpc_available.names[1]
        tags = {
            Name = "private_subnet_2"
        }
    }
    resource "aws_internet_gateway" "my_vpc_igw" {
        vpc_id                      = aws_vpc.my_vpc.id
        tags = {
        Name = "my_vpc_igw"
        }
    }
    resource "aws_route_table" "public_route" {
        vpc_id                      = aws_vpc.my_vpc.id
        route{
        cidr_block                  = var.cidr_block
        gateway_id                  = aws_internet_gateway.my_vpc_igw.id
            }
        tags = {
            Name = "my_vpc_public_route"
        }
    }

    resource "aws_route_table_association" "public_subnet_association" {
        route_table_id              = aws_route_table.public_route.id
        subnet_id                   = aws_subnet.public_subnet_1.id
        depends_on                  = [aws_route_table.public_route, aws_subnet.public_subnet_1]
    }

    resource "aws_route_table_association" "public_subnet_2_association" {
        route_table_id              = aws_route_table.public_route.id
        subnet_id                   = aws_subnet.public_subnet_2.id
        depends_on                  = [aws_route_table.public_route, aws_subnet.public_subnet_2]
    }

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
        from_port                   = 443
        protocol                    = "tcp"
        security_group_id           = aws_security_group.my_vpc_sg_allow_http.id
        to_port                     = 443
        type                        = "egress"
        cidr_blocks                 = [var.cidr_block]
    }
    data "aws_ami" "amzLinux" {
        most_recent = true
        owners = ["amazon"]
        
        filter {
            name   = "name"
            values = ["al2023-ami-2023*"]
            }
    }
    locals {
            DB      ="mydb"
            User    ="alex"
            PW      ="password123"
    }
    resource "aws_instance" "webserver" {
        ami                         = data.aws_ami.amzLinux.id
        instance_type               = "t2.micro"
        key_name                    = "vockey"
        vpc_security_group_ids      = [aws_security_group.my_vpc_sg_allow_http.id]
        subnet_id                   = aws_subnet.public_subnet_1.id
        user_data                   = templatefile("user-data.sh",{
            DB      = local.DB
            User    = local.User
            PW      = local.PW
        })
        tags = {
            Name    = "webserver"
        }
    }