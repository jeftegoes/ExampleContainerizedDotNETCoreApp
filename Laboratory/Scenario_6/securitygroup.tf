data "aws_ip_ranges" "south_america_ec2" {
  regions  = ["sa-east-1"]
  services = ["ec2"]
}

resource "aws_security_group" "from_south_america" {
  name = "from_south_america"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = data.aws_ip_ranges.south_america_ec2.cidr_blocks
  }
  tags = {
    CreateDate = data.aws_ip_ranges.south_america_ec2.create_date
    SyncToken  = data.aws_ip_ranges.south_america_ec2.sync_token
  }
}
