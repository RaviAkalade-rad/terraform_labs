#Terraform block    
terraform {
  required_version = ">=1.1.4"
  required_providers {
    aws ={
       source  = "hashicorp/aws"
       version = "~> 5.0"
  }
  }
}
#provider Block 
provider "aws" {
  profile ="default"
  region = "us-east-1"
  
}