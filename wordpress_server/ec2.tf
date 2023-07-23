data "aws_ami" "amzLinux" {
    most_recent                 = true
    owners                      = ["amazon"]
    
    filter {
        name    = "name"
        values  = ["al2023-ami-2023*"]
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
resource "aws_instance" "CPUtest" {
    ami                         = data.aws_ami.amzLinux.id
    instance_type               = "t2.micro"
    key_name                    = "vockey"
    vpc_security_group_ids      = [aws_security_group.my_vpc_sg_allow_http.id]
    subnet_id                   = aws_subnet.public_subnet_1.id
    user_data                   = templatefile("CPUtest.sh",{})
    tags = {
        Name    = "CPUtest"
    }
}