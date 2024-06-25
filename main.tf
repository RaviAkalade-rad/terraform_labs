/*Discription: This is  first terraform lab
  Auther:Ravindra
  User Story: US 1234
   */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " 5.54.1"
    }
  }
}
provider "aws" {
  
  region = "us-east-1"
  
}



