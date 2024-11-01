provider "aws" {
  shared_credentials_files = [var.shared_credentials_file]
  region                  = "us-east-1"
  profile                 = "default"
}

provider "google" {
  credentials = file("/.json")
  project     = "<project>"
  region      = "europe-west1"
  version     = "~> 2.5.0"
}