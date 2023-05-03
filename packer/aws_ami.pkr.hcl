packer {
  required_plugins {
    amazon = {
      version = " >= 1.0.0 "
      source  = "github.com/hashicorp/amazon"
    }
  }
}   

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "saf_ami" {
    ami_name      = "saf_ami-${local.timestamp}"
    source_ami    = "ami-0ec7f9846da6b0f61"
    instance_type = "t2.micro"
    region        = "eu-central-1"
    ssh_username  = "ubuntu"
}

build {
    sources = [
        "source.amazon-ebs.saf_ami"
    ]
    provisioner "file" {
        source      = "./user_data_docker.sh"
        destination = "/home/ubuntu/user_data_docker.sh"
    }
    provisioner "file" {
        source      = "./aws_sync_s3.sh"
        destination = "/home/ubuntu/aws_sync_s3.sh"
    }
    provisioner "shell" {
      inline = [
    "sudo bash /home/ubuntu/user_data_docker.sh",
    "sudo docker stop html80 ",
    "sudo docker stop html8080 "
  ]
    }

}