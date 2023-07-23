output "ec2_public_wordpress_ip"{
    value = aws_instance.webserver.public_ip   
}