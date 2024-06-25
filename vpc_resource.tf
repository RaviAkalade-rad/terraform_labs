resource "aws_vpc" "tfvpc01"{
    tags = { "Name" = "TFVPC01"}

    cidr_block = "10.10.0.0/16"

}

resource "aws_subnet" "public_subnet" {
        tags = { "Name" = "Public-Subnet"}

        vpc_id = aws_vpc.tfvpc01.id
        cidr_block = "10.10.1.0/24"
        availability_zone = "us-east-1a"
  
}

resource "aws_subnet" "private_subnet" {
        tags = { "Name" = "Private-Subnet"}

        vpc_id = aws_vpc.tfvpc01.id
        cidr_block = "10.10.2.0/24"
        availability_zone = "us-east-1b"
  
}

resource "aws_security_group" "sg_for_webserver" {

    name = "sg_webserver"
    vpc_id = aws_vpc.tfvpc01.id

    ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



  
resource "aws_instance" "webserver02" {
    tags = {
        "Name" = "TFWebServer02"
        }

    ami = "ami-0eaf7c3456e7b5b68"
    instance_type = "t2.micro"
    key_name = "Linux_serverKeypair"
    
    

    subnet_id = aws_subnet.private_subnet.id

    user_data = "/scripts/app-install.sh"
    
   

}

resource "aws_instance" "webserver01" {
    tags = {
        "Name" = "TFWebServer01"
    }

    ami = "ami-0eaf7c3456e7b5b68"
    instance_type = "t2.micro"
    key_name = "Linux_serverKeypair"
    
    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = "true"
    security_groups = [aws_security_group.sg_for_webserver.id]

    user_data = "/scripts/app-install.sh"
   
}
resource "aws_route_table" "route_private" {
    tags = {
      "Name"= "route_private"
    }

      vpc_id = aws_vpc.tfvpc01.id
    
}

resource "aws_internet_gateway" "igw_rt" {

    vpc_id = aws_vpc.tfvpc01.id
  
}

resource "aws_route_table_association" "rta_private" {
        subnet_id = aws_subnet.private_subnet.id
        route_table_id = aws_route_table.route_private.id  
  
}

resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.tfvpc01.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_rt.id
  }

}
resource "aws_lb" "applb_01" {

name = "Appl-load-bal"
internal = false
load_balancer_type = "application"
subnets = [aws_subnet.public_subnet.id,aws_subnet.private_subnet.id]


}
resource "aws_alb_target_group" "alb_target_grp" {
    name = "ALB-Target-Grp"
    vpc_id = aws_vpc.tfvpc01.id
    port = 80
    protocol = "HTTP"
 
}
resource "aws_alb_target_group_attachment" "tg_attach" {
    target_group_arn = aws_alb_target_group.alb_target_grp.id
    target_id = aws_instance.webserver01.id
    
}

resource "aws_alb_target_group_attachment" "tg_attach2" {
    target_group_arn = aws_alb_target_group.alb_target_grp.id
    target_id = aws_instance.webserver02.id
  
}

resource "aws_alb_listener" "alb_ass" {

    load_balancer_arn = aws_lb.applb_01.id
    port = "80"
    protocol = "HTTP"
default_action {

    type = "forward"
    target_group_arn = aws_alb_target_group.alb_target_grp.id

}

  
}