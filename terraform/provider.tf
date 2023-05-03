provider "aws"  {
        region                 = "eu-central-1"
}

#конфигурация для хранения .tfstate на s3

terraform {
        backend "s3" {
                bucket = "terraform-aws-leason-safon686"
                key    = "dev/terraform/terraform.tfstate"
                region = "eu-central-1"
        }
}
