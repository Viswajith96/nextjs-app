provider "aws" {
  profile = "nextjs-project"
  region = var.region
}

terraform {
  required_version = "~> 1.0"
}
