#resource block

data "aws_ami" "amz_linux" {
    owners = ["amazon"]
     most_recent      = true
    filter {
    name = "name"
    values = ["amzn2-ami-kernel*x86_64-gp2"]
   }
}
   # values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240620.0-x86_64-gp2"]
   # To get the name deatils of any ami use commond :  aws ec2 describe-images --image-ids "ami-********"               

  
resource "aws_instance" "docker_host" {

    ami = data.aws_ami.amz_linux.id
    instance_type = "t2.micro"

    vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
    ##vpc_security_group_ids = ["aws_security_group.sg_dock_host"]
    key_name = "Linux_serverKeypair"
    user_data = "userdata.sh"

    
}

