############################################################################################################
## Terraform Script to setup VM on AWS, Find ami ID in AWS Marketplace, using "Ubuntu Server 20.04 LTS"
# Build AWS Access Key
# Terraform  initialize the Environment, "terraform init"
# Terraform Check Script Before Run, "terraform plan" or Use "terraform plan -out terraform_plan_Backup.tfplan"
# Terraform Run Script, "terraform apply" Or Use "terraform apply terraform_plan_Backup.tfplan" Without Approval Promote for Automation
# Terraform Destroy Environment, "terraform destroy" Or Use "terraform destroy -auto-approve" Without Approval Promote for Automation
# Destroy a specific instance "Terraform destroy -target aws_instance.ubuntu[ENTER_INDEX_OF_instance(name num-1)]"
############################################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }
}

provider "aws" {
  region  = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220420"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ubuntu" {
  count         = 2  #change to create more instances
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  tags = {
    Name = "ubuntu_22.04_${count.index + 1}"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because of a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
      # and instance type.
      instance_type
    ]
  }
}


variable "credentials_files" {
  type    = list(string)
}
variable "config_files" {
  type    = list(string)
}

variable "security_token" {
  type    = string
}

variable "session_token" {
  type    = string
}
variable "region" {
  type = string
}
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}