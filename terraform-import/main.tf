provider "aws" {
  region = "ap-southeast-1"
}

import {
  to = aws_vpc.this
  id = "vpc-0c3ca09ad786529d5"
}

import {
    to = aws_subnet.this
    id = "subnet-02d29458df29583cd"
}

resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet"
  }
}

resource "aws_vpc" "this" {

}