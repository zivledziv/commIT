terraform {
  backend "s3" {
    bucket         = "commit-state-bucket-ziv"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
