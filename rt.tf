#  public subnet route table  
resource "aws_route_table" "vpc_3_public_route_table" {
  vpc_id = aws_vpc.vpc_3.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc3_igw.id
  }

  route {
    cidr_block         = var.vpc_1_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block         = var.vpc_2_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }




  tags = {
    Name = "${var.env}-rt-3-vpc-3"
  }
}
resource "aws_route_table_association" "associate_public_rt_to_subnet" {
  subnet_id      = aws_subnet.vpc_3_public_subnet_1.id
  route_table_id = aws_route_table.vpc_3_public_route_table.id
}


resource "aws_route_table" "vpc_3_private_route_table" {
  vpc_id = aws_vpc.vpc_3.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc3_nat.id
  }

  tags = {
    Name = "centralized-private-rt"
  }
}

resource "aws_route_table_association" "association_private_rt_to_subnet" {
  subnet_id      = aws_subnet.vpc_3_private_subnet_1.id
  route_table_id = aws_route_table.vpc_3_private_route_table.id
}

#  Vpc_1 route table and associate
resource "aws_route_table" "vpc1_private_route_table" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }



  tags = {
    Name = "${var.env}-rt-1-vpc-1"
  }

}

resource "aws_route_table_association" "associate_route_table_1_to_subnet1" {
  subnet_id      = aws_subnet.vpc_1_private_subnet_1.id
  route_table_id = aws_route_table.vpc1_private_route_table.id
}

resource "aws_route_table_association" "associate_route_table_1_to_subnet2" {
  subnet_id      = aws_subnet.vpc_1_private_subnet_2.id
  route_table_id = aws_route_table.vpc1_private_route_table.id
}

#  Vpc_2 route table and associate
resource "aws_route_table" "vpc2_private_route_table" {
  vpc_id = aws_vpc.vpc_2.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }


  tags = {
    Name = "${var.env}-rt-2-vpc-2"
  }

}

resource "aws_route_table_association" "associate_route_table_2_to_subnet" {
  subnet_id      = aws_subnet.vpc_2_private_subnet.id
  route_table_id = aws_route_table.vpc2_private_route_table.id
}




