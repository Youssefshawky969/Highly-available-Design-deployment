# ---- Internet Gateway for Public Subnet ----
resource "aws_internet_gateway" "vpc3_igw" {
  vpc_id = aws_vpc.vpc_3.id
  tags = {
    Name = "${var.env}-igw-vpc-3"
  }
}
