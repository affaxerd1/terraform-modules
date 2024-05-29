terraform {
  backend "s3" {
    bucket = "bucket-affaxerd"
    key = "dev-affaxerd"
    region = "eu-west-2"
    profile = "terraform-user"
    
  }
}