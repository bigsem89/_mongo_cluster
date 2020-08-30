#----------------------------------------#
# My terraform                           #
#                                        #
# Build Servers                          #
#                                        #
# Made by Semyon Aronov                  #
#----------------------------------------#
variable "ami_image" {}


provider "aws" {}

# aws instances
resource "aws_instance" "mongo-test1" {
    ami                    = var.ami_image
    instance_type          = "t3.micro"
    key_name               = "Mongo_Cluster"
    vpc_security_group_ids = [aws_security_group.Mongo-sg.id]

  tags = {
     Name  = "mongo-test1"
     Owner = "Semyon Aronov"
  }
}

resource "aws_instance" "mongo-test2" {
    ami                    = var.ami_image
    instance_type          = "t3.micro"
    key_name               = "Mongo_Cluster"
    vpc_security_group_ids = [aws_security_group.Mongo-sg.id]

  tags = {
     Name  = "mongo-test2"
     Owner = "Semyon Aronov"
  }
}

resource "aws_instance" "mongo-test3" {
    ami                    = var.ami_image
    instance_type          = "t3.micro"
    key_name               = "Mongo_Cluster"
    vpc_security_group_ids = [aws_security_group.Mongo-sg.id]

  tags = {
     Name  = "mongo-test3"
     Owner = "Semyon Aronov"
  }
}

# AWS Security groups (firewall rules)
resource "aws_security_group" "Mongo-sg" {
    name        = "WebServer Security Group"
    description = "My security group"

    dynamic "ingress" {
      for_each = ["22", "27017"]
      content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["109.252.62.10/32"]
      }
    }


    ingress {
      from_port = 27017
      to_port = 27017
      protocol = "tcp"
      cidr_blocks = ["172.31.0.0/16"]
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

# create an ansible inventory file
resource "null_resource" "ansible-provision" {
  depends_on = [aws_instance.mongo-test1, aws_instance.mongo-test2, aws_instance.mongo-test3]

  provisioner "local-exec" {
    command = "echo [mongo_master] > hosts"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.mongo-test1.tags.Name} ansible_host=${aws_instance.mongo-test1.public_ip} >> hosts"
  }

  provisioner "local-exec" {
    command = "echo # >> hosts"
  }

  provisioner "local-exec" {
    command = "echo [mongo_replicas] >> hosts"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.mongo-test2.tags.Name} ansible_host=${aws_instance.mongo-test2.public_ip} >> hosts"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.mongo-test3.tags.Name} ansible_host=${aws_instance.mongo-test3.public_ip} >> hosts"
  }

  provisioner "local-exec" {
    command = "echo # >> hosts"
  }

  provisioner "local-exec" {
    command = "echo [mongo:children] >> hosts"
  }

  provisioner "local-exec" {
    command = "echo mongo_master >> hosts"
  }

  provisioner "local-exec" {
    command = "echo mongo_replicas >> hosts"
  }
}

output "mongo-test1_ip" {
  value = aws_instance.mongo-test1.private_ip
}

output "mongo-test2_ip" {
  value = aws_instance.mongo-test2.private_ip
}

output "mongo-test3_ip" {
  value = aws_instance.mongo-test3.private_ip
}
