variable "aws_region" {
  description = "aws region"
  type = string
  
}

variable "vpc_cidr" {
    type = string
    
  
}

variable "private_subnet_cidr" {
  type = string
  
}

variable "public_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}