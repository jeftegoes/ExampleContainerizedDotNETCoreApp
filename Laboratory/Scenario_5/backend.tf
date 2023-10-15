terraform {
  backend "s3" {
    bucket = "terraform-state-test-2l34k5r"
    region = "sa-east-1"
  }
}
