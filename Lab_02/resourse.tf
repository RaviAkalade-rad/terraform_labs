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
    
    #vpc_security_group_ids = ["aws_security_group.sg_dock_host"] this command gave below error
    
    /*Error: creating EC2 Instance: operation error EC2: RunInstances, https response error StatusCode: 400, RequestID: 4b2b5901-6662-447b-b6a3-427cca78d8f5, api error InvalidParameterValue: Value () for parameter groupId is invalid. The value cannot be empty
│
│   with aws_instance.docker_host,
│   on resourse.tf line 15, in resource "aws_instance" "docker_host":
│   15: resource "aws_instance" "docker_host" {*/

    key_name = "Linux_serverKeypair"
    user_data = file("userdata.sh")
    
    /*user_data =  <<-EOF

         #!/bin/bash
        yum install docker -y
        service docker start
        usermod -a -G docker ec2-user
        chkconfig docker on
        yum install -y git
        sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) \
        -o /usr/local/bin/docker-compose
        mv /usr/local/bin/docker-compose /usr/bin/docker-compose
        chmod +x /usr/bin/docker-compose

        EOF*/
    
}

