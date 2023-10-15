variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "INSTANCE_USERNAME" {
  type    = string
  default = "Terraform"
}

variable "INSTANCE_PASSWORD" {
  type    = string
  default = "12345"
}

variable "PATH_TO_PRIVATE_KEY" {
  type    = string
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  type    = string
  default = "mykey.pub"
}
