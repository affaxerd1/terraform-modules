// allocate elastic ip. this eip will be used for the nat gateway
resource "aws_eip" "eip_for_nat_gateway" {
  vpc = true

  tags = {
    Name = "nat_gateway_az1_eip"
  }
}

// allocate elastic ip. this eip will be used for the nat gateway
resource "aws-eip" "eip_for_nat_gateway_az2" {
  vpc = true

  tags = {
    Name = "eip_for_nat_gateway_az2"
  }
}

// create nat gateway in the public subnet az1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway.id
    subnet_id     = aws_subnet.public_subnet_az1.id

    tags = {
        Name = "nat_gateway_az1"
    }

    depends_on = [var.internet_gateway]
}

//create nat gateway in the public subnet az2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
    subnet_id     = aws_subnet.public_subnet_az2.id

    tags = {
        Name = "nat_gateway_az2"
    }

    //To ensure proper ordering, it is recommended to add 
    depends_on = [var.internet_gateway]
}

// create route table for private subnet az1 and route the traffic to nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }
  tags = {
    Name = "private_route_table_az1"
  }
}

//associate private app subnet az1 with the route table
resource "aws_route_table_association" "private_subnet_association_az1" {
  subnet_id      = var.private_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

//associate private data subnet az1 with private route table
resource "aws_route_table_association" "private_data_subnet_association_az1" {
  subnet_id      = var.private_data_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

//create private route table az2 and route the traffic to nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }
  tags = {
    Name = "private_route_table_az2"
  }
}

//associate private app subnet az2 with the route table
resource "aws_route_table_association" "private_subnet_association_az2" {
  subnet_id      = var.private_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}

//associate private data subnet az2 with private route table
resource "aws_route_table_association" "private_data_subnet_association_az2" {
  subnet_id      = var.private_data_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}



