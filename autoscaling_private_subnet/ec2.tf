provider "aws" {
    region                      = "eu-central-1"
    profile                     = "account2"
}
data "aws_ami" "amzLinux" {
    most_recent                 = true
    owners                      = ["amazon"]
    filter {
        name    = "name"
        values  = ["al2023-ami-2023*"]
        }
}
resource "aws_instance" "CPUtest" {
    ami                         = data.aws_ami.amzLinux.id
    instance_type               = "t2.micro"
    vpc_security_group_ids      = [data.aws_security_groups.my-sg.ids[0]]
    subnet_id                   = data.aws_subnet.public_sub_1.id
    user_data                   = templatefile("../wordpress_server/CPUtest.sh",{})
    tags = {
        Name    = "CPUtest"
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
    vpc_security_group_ids      = [data.aws_security_groups.my-sg.ids[0]]
    subnet_id                   = data.aws_subnet.public_sub_1.id
    user_data                   = templatefile("../wordpress_server/user-data.sh",{
        DB      = local.DB
        User    = local.User
        PW      = local.PW
    })
    tags = {
        Name    = "webserver"
    }
}
