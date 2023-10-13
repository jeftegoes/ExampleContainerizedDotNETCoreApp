resource "aws_instance" "my_ec2_via_terraform" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
}
