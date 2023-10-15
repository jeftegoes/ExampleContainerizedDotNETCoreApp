resource "aws_instance" "my_ec2_via_terraform" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.my_ec2_via_terraform.private_ip} >> private_ips.txt"
  }
}

output "my_ip" {
  value = aws_instance.my_ec2_via_terraform.public_ip
}
