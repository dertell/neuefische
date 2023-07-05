
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "deham6ec2"{
    ami = "ami-02d8bad0a1da4b6fd"
    instance_type = "t2.micro"
    key_name = "deham630062023"
    vpc_security_group_ids = ["sg-075fed123413fd78d"]
    subnet_id = "subnet-035fe92ae49c8a24b"
    tags = {
        Name = "deham6ec2-two"
    }
}

resource "aws_s3_bucket" "dev" {
  bucket = "my-new-neuefische-terraform-bucket"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
