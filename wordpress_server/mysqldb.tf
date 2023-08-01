resource "aws_db_instance" "mysql-db" {
  allocated_storage    = 20
  db_name              = local.DB
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = local.User
  password             = local.PW
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name  = aws_db_subnet_group.subnetgroup.name
  vpc_security_group_ids = [aws_security_group.mysqldb-sg.id]
}
resource "aws_db_subnet_group" "subnetgroup" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}