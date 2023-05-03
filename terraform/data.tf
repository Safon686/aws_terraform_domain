#конфигурация для загрузки .tfstate с s3
/*
data "terraform_remote_state" "main" {
    backend = "s3"
    config = {
            bucket = "terraform-aws-leason-safon686"
            key    = "dev/terraform/terraform.tfstate"
            region = var.region
    }
}
*/
data "aws_ami" "latest_ubuntu" {
    owners = ["719373697694"]
    most_recent = true
    filter {
        name = "name"
        values = ["saf_ami-*"]
    }
}