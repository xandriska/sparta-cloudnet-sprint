# create an EC2 instance.

## provider block - what providers do we need? AWS/azure/gcp etc ##

provider "aws" {
  region = "eu-west-1"

  # with a provider given, terraform will download all required deps/plugins on command 'terraform init'
}

# Creation of the main VPC which will house our subnets.
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "se-georgina-tf-vpc"
  }
}

# Creation of the public subnet. 
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "se-georgina-tf-public-subnet"
  }
}

# Creation of the private subnet.
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "se-georgina-tf-private-subnet"
  }
}

# Creation of the internet gateway. It attaches to the VPC by using the VPC ID.
# Terraform is smart and knows what attributes each resource can have, so even though
# we have not explicitly inputted an ID for the VPC, Terraform can retrieve this
# information on 'terraform apply'. 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "se-georgina-tf-igw"
  }
}

# Creation of the route table and attachment to the VPC.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "se-georgina-tf-publicrt"
  }
}

# Creation of the route itself, attaching to the route table, attaching to
# the internet gateway, and specifying a destination CIDR block. 
resource "aws_route" "public_route" {
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
}

# Create a route table association.
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a security group for the app instance in the public subnet.
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "se-georgina-tf-app-sg"
  }
}

# Create a security group for the db instance in the private subnet.
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"] # Public subnet
  }


  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.2.0/24"] # Public subnet
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "se-georgina-tf-db-sg"
  }
}

# Creation of the DB instance from my own AMI.
resource "aws_instance" "db_instance" {
  ami                         = var.db_instance_ami
  instance_type               = var.db_instance_type
  associate_public_ip_address = false
  key_name                    = var.project_key_pair
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]

  tags = {
    Name = "se-georgina-tf-db"
  }
}

# Create an EC2 instance for the app from my own AMI.

# On the subject of the DB private IP: this method here works because all of my resources are
# in the same folder. More normally, resources would not be held in one file, and in that case,
# we would have to use templates with modules and output blocks. 
resource "aws_instance" "app_instance" {
  # AMI ID
  ami                         = var.app_instance_ami
  instance_type               = var.app_instance_type
  associate_public_ip_address = true
  key_name                    = var.project_key_pair
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  user_data                   = <<-EOF
    #!/bin/bash
    sleep 20
    cd /home/ubuntu
    cd se-app-deployment-files/nodejs20-se-test-app-2025/app
    export DB_HOST=mongodb://${aws_instance.db_instance.private_ip}:27017/posts
    node seeds/seed.js
    sudo npm install
    pm2 start app.js
    EOF

  # give it a name on AWS
  tags = {
    Name = "se-georgina-tf-app-instance"
  }


}














