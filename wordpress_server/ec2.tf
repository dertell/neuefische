data "aws_ami" "amzLinux" {
    most_recent                 = true
    owners                      = ["amazon"]    
    filter {
        name    = "name"
        values  = ["al2023-ami-2023*x86_64"]
        }
}
locals {
    DB      ="mydb"
    User    ="alex"
    PW      ="password123"
    host    =aws_db_instance.mysql-db.address
}

resource "aws_instance" "bastion-host" {
    ami                         = data.aws_ami.amzLinux.id
    instance_type               = "t2.micro"
    key_name                    = "vockey"
    vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
    subnet_id                   = aws_subnet.public_subnet_1.id
    tags = {
        Name    = "Bastion"
    }
}