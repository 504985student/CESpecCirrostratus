provider "aws" {
  shared_credentials_files = [var.shared_credentials_file]
  region                  = "us-east-1"
  profile                 = "default"
}

