#   NAT Gateway in public subnet
resource "aws_nat_gateway" "vpc3_nat" {
  allocation_id = aws_eip.vpc3_nat_eip.id
  subnet_id     = aws_subnet.vpc_3_public_subnet_1.id

  tags = {
    Name = "${var.env}-nat-vpc-3"
  }
}

#     Elastic IP and NAT Gateway for public Subnet 
resource "aws_eip" "vpc3_nat_eip" {
  tags = {
    Name = "${var.env}-eip-nat"
  }
}