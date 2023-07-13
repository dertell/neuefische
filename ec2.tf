resource "aws_instance" "this" {
  ami                     = "ami-0ae49954dfb447966"
  instance_type           = "t2.micro"
  key_name                = "vockey"
  vpc_security_group_ids  = [aws_security_group.devVPC_sg_allow_ssh_http.id]
  subnet_id               = aws_subnet.devVPC_public_subnet.id
  tags = {
    name = "dev_terraform_ec2"
  }
  provisioner "local-exec"{
    command = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> allinstancedetails"
  }
}