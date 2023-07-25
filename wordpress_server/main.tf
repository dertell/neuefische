terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}
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
    resource "aws_route_table" "private_route" {
        vpc_id                      = aws_vpc.my_vpc.id
        tags = {
            Name = "my_vpc_private_route"
        }
    }
    resource "aws_route_table_association" "private_subnet_association" {
        route_table_id              = aws_route_table.private_route.id
        subnet_id                   = aws_subnet.private_subnet_1.id
        depends_on                  = [aws_route_table.private_route, aws_subnet.private_subnet_1, aws_vpc_endpoint.s3]
    }
    resource "aws_route_table_association" "private_subnet_2_association" {
        route_table_id              = aws_route_table.private_route.id
        subnet_id                   = aws_subnet.private_subnet_2.id
        depends_on                  = [aws_route_table.private_route, aws_subnet.private_subnet_2, aws_vpc_endpoint.s3]
    }
    resource "aws_vpc_endpoint" "s3" {
        vpc_id       = aws_vpc.my_vpc.id
        service_name = "com.amazonaws.us-west-2.s3"
            tags = {
                Namme = "S3_Endpoint"
            }
        }
    resource "aws_vpc_endpoint_route_table_association" "example" {
        route_table_id  = aws_route_table.private_route.id
        vpc_endpoint_id = aws_vpc_endpoint.s3.id
}