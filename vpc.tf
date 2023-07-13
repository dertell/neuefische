# Query all available Availability Zone; we will use specific availability zone using index - The Availability Zones data source
# provides access to the list of AWS availabililty zones which can be accessed by an AWS account specific to region configured in the provider.

data "aws_availability_zones" "devVPC_available"{}
resource "aws_vpc" "devVPC"{
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames=true
    enable_dns_support = true
    tags = {
        Name = "dev_terraform_vpc"
    }
}
# Public subnet public CIDR block available in vars.tf and provisionersVPC
resource "aws_subnet" "devVPC_public_subnet"{
    cidr_block = "10.0.1.0/28"
    vpc_id = aws_vpc.devVPC.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.devVPC_available.names[1]
    tags = {
        Name = "dev_terraform_vpc_public_subnet"
    }
}
resource "aws_subnet" "private_subnet"{
    cidr_block = "10.0.2.0/28"
    vpc_id = aws_vpc.devVPC.id
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.devVPC_available.names[1]
    tags = {
        Name = "dev_terraform_vpc_private_subnet"
    }
}
# To access EC2 instance inside a Virtual Private Cloud (VPC) we need an Internet Gateway
# and a routing table Connecting the subnet to the Internet Gateway
# Creating Internet Gateway
# Provides a resource to create a VPC Internet Gateway
resource "aws_internet_gateway" "devVPC_IGW"{
    vpc_id                = aws_vpc.devVPC.id
    tags = {
        Name = "dev_terraform_vpc_igw"
    }
}
# Provides a resource to create a VPC routing table
resource "aws_route_table" "devVPC_public_route"{
    vpc_id                = aws_vpc.devVPC.id
    route{
        cidr_block = var.cidr_blocks
        gateway_id = aws_internet_gateway.devVPC_IGW.id
    }
    tags = {
        Name = "dev_terraform_vpc_public_route"
    }
}
# Provides a resource to create an association between a Public Route Table and a Public Subnet
resource "aws_route_table_association" "public_subnet_association" {
    route_table_id        = aws_route_table.devVPC_public_route.id
    subnet_id             = aws_subnet.devVPC_public_subnet.id
    depends_on            = [aws_route_table.devVPC_public_route, aws_subnet.devVPC_public_subnet]
}

resource "aws_security_group" "devVPC_sg_allow_ssh_http"{
    vpc_id                = aws_vpc.devVPC.id
    name                  = "devVPC_terraform_vpc_allow_ssh_http"
    tags = {
        Name = "devVPC_terraform_sg_allow_ssh_http"
    }
}
# Ingress Security Port 22 (Inbound) - Provides a security group rule resource (https://registry.terraform.io.providers/hashicorp/aws/latest/docs/resources/security_group_rule)
resource "aws_security_group_rule" "devVPC_ssh_ingress_access"{
    from_port             = 22
    protocol              = "tcp"
    security_group_id     = aws_security_group.devVPC_sg_allow_ssh_http.id
    to_port               = 22
    type                  = "ingress"
    cidr_blocks           = [var.cidr_blocks]
}
# Ingress Security Port 80 (Inbound)
resource "aws_security_group_rule" "devVPC_http_ingress_access"{
    from_port             = 80
    protocol              = "tcp"
    security_group_id     = aws_security_group.devVPC_sg_allow_ssh_http.id
    to_port               = 80
    type                  = "ingress"
    cidr_blocks           = [var.cidr_blocks]
}
# Ingress Security Port 8080 (Inbound)
resource "aws_security_group_rule" "devVPC_http8080_ingress_access"{
    from_port             = 8080
    protocol              = "tcp"
    security_group_id     = aws_security_group.devVPC_sg_allow_ssh_http.id
    to_port               = 8080
    type                  = "ingress"
    cidr_blocks           = [var.cidr_blocks]
}
