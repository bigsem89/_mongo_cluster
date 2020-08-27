#----------------------------------------
# My terraform
#
#Build Servers
#
#Made by Semyon Aronov

provider "aws" {}

resource "aws_instance" "mongo-test1" {
    ami                    = "ami-03d4fca0a9ced3d1f" #Ubuntu 18.04 linux AMI
    instance_type          = "t3.micro"
    key_name               = "Mongo_Cluster"
    vpc_security_group_ids = [aws_security_group.Mongo-sg.id]

  tags = {
     Name  = "mongo-test1"
     Owner = "Semyon Aronov"
  }
}

resource "aws_instance" "mongo-test2" {
    ami                    = "ami-03d4fca0a9ced3d1f" #Ubuntu 18.04 linux AMI
    instance_type          = "t3.micro"
    key_name               = "Mongo_Cluster"
    vpc_security_group_ids = [aws_security_group.Mongo-sg.id]

  tags = {
     Name  = "mongo-test2"
     Owner = "Semyon Aronov"
  }
}

resource "aws_instance" "mongo-test3" {
    ami                    = "ami-03d4fca0a9ced3d1f" #Ubuntu 18.04 linux AMI
    instance_type          = "t3.micro"
    key_name               = "Mongo_Cluster"
    vpc_security_group_ids = [aws_security_group.Mongo-sg.id]

  tags = {
     Name  = "mongo-test3"
     Owner = "Semyon Aronov"
  }
}

resource "aws_security_group" "Mongo-sg" {
    name        = "WebServer Security Group"
    description = "My security group"

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["109.252.62.10/32"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
       Name  = "MongoDb Security Group"
       Owner = "Semyon Aronov"
    }
}

output "WebServer_instance_id" {
  value = aws_instance.mongo-test1.id
}
