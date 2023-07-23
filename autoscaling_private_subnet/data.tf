data "aws_vpc" "my_vpc" {
    filter {
        name = "tag:Name"
        values = ["my-vpc"]
    }
}
data "aws_subnet" "public_sub_1" {
  filter {
    name = "tag:Name"
    values = ["my-subnet-public1-eu-central-1a"]
  }
}
data "aws_subnet" "public_sub_2" {
  filter {
    name = "tag:Name"
    values = ["my-subnet-public2-eu-central-1b"]
  }
}
data "aws_subnet" "private_sub_1" {
  filter {
    name = "tag:Name"
    values = ["my-subnet-private1-eu-central-1a"]
  }
}
data "aws_subnet" "private_sub_2" {
  filter {
    name = "tag:Name"
    values = ["my-subnet-private2-eu-central-1b"]
  }
}
data "aws_security_groups" "my-sg" {
    tags = {
        Name = "httpaccess"
    }
}