output "ami_name" {
  value = data.aws_ami.amz_linux.name
}
output "ami_id" {
  value = data.aws_ami.amz_linux.id
}
output"pub_dns"{
    value = "http://${aws_instance.docker_host.public_dns}"
    #sensitive = true
}