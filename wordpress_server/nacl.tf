#resource "aws_network_acl" "main" {
#  vpc_id = aws_vpc.my_vpc.id
#
#  egress {
#    protocol   = "tcp"
#    rule_no    = 100
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    from_port  = 443
#    to_port    = 443
#  }
#  egress {
#    protocol   = "tcp"
#    rule_no    = 200
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    from_port  = 80
#    to_port    = 80
#  }
#  ingress {
#    protocol   = "tcp"
#    rule_no    = 300
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    from_port  = 80
#    to_port    = 80
#  }
#  ingress {
#    protocol   = "tcp"
#    rule_no    = 400
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    from_port  = 443
#    to_port    = 443
#  }
#
#  tags = {
#    Name = "main-nacl"
#  }
#}
#resource "aws_network_acl_association" "nacl-association-2" {
#  network_acl_id = aws_network_acl.main.id
#  subnet_id      = aws_subnet.public_subnet_2.id
#}
#resource "aws_network_acl_association" "nacl-association-1" {
#  network_acl_id = aws_network_acl.main.id
#  subnet_id      = aws_subnet.public_subnet_1.id
#}