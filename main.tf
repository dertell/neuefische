
provider "aws" {
  region = "eu-central-1"
}
/*
resource "aws_instance" "deham6ec2"{
    ami = "ami-02d8bad0a1da4b6fd"
    instance_type = "t2.micro"
    key_name = "terraform-key"
    vpc_security_group_ids = ["sg-075fed123413fd78d"]
    subnet_id = "subnet-035fe92ae49c8a24b"
    tags = {
        Name = "deham6ec2-two"
    }
}
*/

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket121511"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}