# var.a-string OR "${var.a-string}"
variable "a-string" {
  type    = string
  default = "Hello World!"
}

# var.this-is-a-number
variable "this-is-a-number" {
  type    = number
  default = 10
}

# var.true-or-false
variable "true-or-false" {
  type    = bool
  default = true
}

# var.this-is-a-list
# var.this-is-a-list[0]
# element(var.this-is-a-list, 2)
# slice(var.this-is-a-list, 0, 2)
variable "this-is-a-list" {
  type    = list(number)
  default = [12, 21, 32]
}

# var.this-is-a-map OR "${var.this-is-a-map}"
# var.this-is-a-map["mykey1"]
variable "this-is-a-map" {
  type = map(string)
  default = {
    mykey1 = "my_value_1",
    mykey2 = "my_value_2",
  }
}

# var.AWS_REGION
variable "AWS_REGION" {
  type = string
}

# var.AMIS[var.AWS_REGION]
variable "AMIS" {
  type = map(string)
  default = {
    "eu-west-1" = "my_ami_1",
    "sa-east-1" = "my_ami_2"
  }
}

# var.this-is-an-object
# var.this-is-an-object.firstname
variable "this-is-an-object" {
  type = object({
    firstname   = string,
    housenumber = number
  })
  default = {
    firstname   = "Jefté",
    housenumber = 112
  }
}

# var.this-is-a-tuple
# var.this-is-a-tuple[1]
variable "this-is-a-tuple" {
  type    = tuple([number, string, bool])
  default = [0, "test", false]
}
