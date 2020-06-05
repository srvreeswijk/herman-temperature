terraform {
  backend "s3" {
    bucket = "herman-koeling-temp"
    key    = "IoT/herman-koeling-temp.tfstate"
    region = "eu-central-1"
  }
}