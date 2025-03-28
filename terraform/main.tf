provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr # 65,536 ip

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Main IGW"
  }
}

# Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route{
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.main_igw.id

  }

  tags = {
    Name = "Public RT"
  }
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true 

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "public_subnet_rt" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "main_sg" {
  name = "Main SG"
  description = "Allow ssh port 22 "
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.public_cidr]

  }
  ingress {
    from_port = 80 
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = [ var.public_cidr ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ var.public_cidr]
  }
}

resource "aws_instance" "main_instance" {
  ami = "ami-071226ecf16aa7d96"
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [ aws_security_group.main_sg.id ]
  associate_public_ip_address = true 
  key_name = var.key_name
  user_data = file("script.sh")

  tags = {
    Name = "Main instance"
  }
}