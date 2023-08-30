terraform {
  backend "s3" {
    bucket = "hackworth-playground"
    key    = "state"
    region = "us-west-2"
  }
}
