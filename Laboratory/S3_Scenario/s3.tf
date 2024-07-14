resource "aws_s3_bucket" "my_personal_bucket" {
  bucket = "books-images-${var.account-id}"

  tags = {
    Name        = "My bucket of books"
    Environment = "Dev"
  }
}
