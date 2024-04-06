terraform {
  backend "s3" {
    bucket = "nextjs-project-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}


