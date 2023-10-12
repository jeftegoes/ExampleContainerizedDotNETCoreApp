# var.myvar OR "${var.myvar}"
variable "myvar" {
  type    = string
  default = "Hello Terraform!"
}

# var.mymap OR "${var.mymap}"
# var.mymap["mykey1"]
variable "mymap" {
  type = map(string)
  default = {
    mykey1 = "my_value_1",
    mykey2 = "my_value_2",
  }
}

# var.mylist
# var.mylist[0]
# element(var.mylist, 2)
# slice(var.mylist, 0, 2)
variable "mylist" {
  type    = list(number)
  default = [1, 2, 3]
}
