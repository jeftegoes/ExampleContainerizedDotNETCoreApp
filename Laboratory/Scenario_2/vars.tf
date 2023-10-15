variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "AMIS" {
  type = map(string)
  default = {
    "sa-east-1" = "ami-03376b64cbb65efec"
  }
}

variable "INSTANCE_USERNAME" {
  type    = string
  default = "ubuntu"
}

variable "PATH_TO_PRIVATE_KEY" {
  type    = string
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  type    = string
  default = "mykey.pub"
}
