#     Transit Gateway 
resource "aws_ec2_transit_gateway" "tgw" {
  default_route_table_association = "disable"
  tags = {
    Name = "${var.env}-tgw"
  }
}

# TGW Route table
resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.env}-tgw-rt"
  }
}

# Attach VPCs to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_1.id
  subnet_ids         = [aws_subnet.vpc_1_private_subnet_1.id, aws_subnet.vpc_1_private_subnet_2.id]
  tags = {
    Name = "${var.env}-tgw-attachment-vpc-1"
  }
}


resource "aws_ec2_transit_gateway_route" "route_to_vpc_1" {
  destination_cidr_block         = var.vpc_1_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_2.id
  subnet_ids         = [aws_subnet.vpc_2_private_subnet.id]
  tags = {
    Name = "${var.env}-tgw-attachment-vpc-2"
  }
}


resource "aws_ec2_transit_gateway_route" "route_to_vpc_2" {
  destination_cidr_block         = var.vpc_2_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc3_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_3.id
  subnet_ids         = [aws_subnet.vpc_3_private_subnet_1.id, aws_subnet.vpc_3_private_subnet_2.id]
  tags = {
    Name = "${var.env}-tgw-attachment-vpc-3"
  }
}


resource "aws_ec2_transit_gateway_route" "route_to_vpc_3" {
  destination_cidr_block         = var.vpc_3_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc3_attachment.id
}

resource "aws_ec2_transit_gateway_route" "route_to_igw" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc3_attachment.id
}

# Associate the attachment to TGW
resource "aws_ec2_transit_gateway_route_table_association" "vpc1_attach_route_association" {

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id

}

resource "aws_ec2_transit_gateway_route_table_association" "vpc2_attach_route_association" {

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id

}

resource "aws_ec2_transit_gateway_route_table_association" "vpc3_attach_route_association" {

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc3_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id

}


# Enable Propagation from Each VPC to the Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table_propagation" "vpc1_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpc2_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpc3_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc3_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}