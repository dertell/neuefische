output "vpc_id"{
    value = aws_vpc.devVPC.id    
}
output "aws_internet_gateway"{
    value = aws_internet_gateway.devVPC_IGW.id   
}
output "public_subnet"{
    value = aws_subnet.devVPC_public_subnet.id  
}
output "security_group"{
    value = aws_security_group.devVPC_sg_allow_ssh_http.id 
}

/*
output "aws_instance"{
    value=aws_instance.jenkins-instance.id
}
# For more attributes https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference
output "public_ip"{
    value = aws_instance.jenkins-instance.public_ip
}
output "public_dns"{
    value = aws_instance.jenkins-instance.public_dns
}
*/