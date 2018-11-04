# Data
data "aws_availability_zones" "available" {}
locals {
  azs = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
}

# VPC
resource "aws_vpc" "teleport" {
  cidr_block            = "${var.vpc_cidr}"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags {
    Name = "${var.cluster_main_name}"
  }
}

# IGW
resource "aws_internet_gateway" "teleport" {
  vpc_id = "${aws_vpc.teleport.id}"
  tags {
    Name = "${var.cluster_main_name}"
  }
}


# Public
resource "aws_subnet" "public" {
  count             = "${length(local.azs)}"
  vpc_id            = "${aws_vpc.teleport.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, var.cidr_split["public"]+count.index)}"
  availability_zone = "${element(local.azs, count.index)}"

  tags {
    Name = "${var.cluster_main_name}-public-${element(local.azs, count.index)}"
  }
}

resource "aws_route_table" "public" {
  count  = "${length(local.azs)}"
  vpc_id = "${aws_vpc.teleport.id}"

  tags {
    Name = "${var.cluster_main_name}-public-${element(local.azs, count.index)}"
  }
}

resource "aws_route" "public_gateway" {
  count                  = "${length(local.azs)}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.teleport.id}"
  depends_on             = ["aws_route_table.public"]
}

resource "aws_route_table_association" "public" {
  count          = "${length(local.azs)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

# Protected

resource "aws_subnet" "protected" {
  count             = "${length(local.azs)}"
  vpc_id            = "${aws_vpc.teleport.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, var.cidr_split["protected"]+count.index)}"
  availability_zone = "${element(local.azs, count.index)}"

  tags {
    Name = "${var.cluster_main_name}-protected-${element(local.azs, count.index)}"
  }
}

resource "aws_route_table" "protected" {
  count  = "${length(local.azs)}"
  vpc_id = "${aws_vpc.teleport.id}"

  tags {
    Name = "${var.cluster_main_name}-protected-${element(local.azs, count.index)}"
  }
}

resource "aws_route" "protected_gateway" {
  count                  = "${length(local.azs)}"
  route_table_id         = "${element(aws_route_table.protected.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id             = "${element(aws_nat_gateway.teleport.*.id, count.index)}"
  depends_on             = ["aws_route_table.protected"]
}

resource "aws_route_table_association" "protected" {
  count          = "${length(local.azs)}"
  subnet_id      = "${element(aws_subnet.protected.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.protected.*.id, count.index)}"
}

# Private

resource "aws_subnet" "private" {
  count             = "${length(local.azs)}"
  vpc_id            = "${aws_vpc.teleport.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, var.cidr_split["private"]+count.index)}"
  availability_zone = "${element(local.azs, count.index)}"

  tags {
    Name = "${var.cluster_main_name}-private-${element(local.azs, count.index)}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(local.azs)}"
  vpc_id = "${aws_vpc.teleport.id}"

  tags {
    Name = "${var.cluster_main_name}-private-${element(local.azs, count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(local.azs)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

# NAT

resource "aws_eip" "nat" {
  count = "${length(local.azs)}"
  vpc   = true
  tags {
    Name = "${var.cluster_main_name}"
  }
}

resource "aws_nat_gateway" "teleport" {
  count         = "${length(local.azs)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_subnet.public", "aws_internet_gateway.teleport"]
  tags {
    Name = "${var.cluster_main_name}"
  }
}
