
# VPC
resource "aws_vpc" "teleport_sub" {
  cidr_block            = "${var.vpc_cidr}"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags {
    Name = "${var.cluster_sub_name}"
  }
}

# IGW
resource "aws_internet_gateway" "teleport_sub" {
  vpc_id = "${aws_vpc.teleport_sub.id}"
  tags {
    Name = "${var.cluster_sub_name}"
  }
}


# Public
resource "aws_subnet" "public_sub" {
  count             = "${length(local.azs)}"
  vpc_id            = "${aws_vpc.teleport_sub.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, var.cidr_split["public"]+count.index)}"
  availability_zone = "${element(local.azs, count.index)}"

  tags {
    Name = "${var.cluster_sub_name}-public-${element(local.azs, count.index)}"
  }
}

resource "aws_route_table" "public_sub" {
  count  = "${length(local.azs)}"
  vpc_id = "${aws_vpc.teleport_sub.id}"

  tags {
    Name = "${var.cluster_sub_name}-public-${element(local.azs, count.index)}"
  }
}

resource "aws_route" "public_gateway_sub" {
  count                  = "${length(local.azs)}"
  route_table_id         = "${element(aws_route_table.public_sub.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.teleport_sub.id}"
  depends_on             = ["aws_route_table.public_sub"]
}

resource "aws_route_table_association" "public_sub" {
  count          = "${length(local.azs)}"
  subnet_id      = "${element(aws_subnet.public_sub.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public_sub.*.id, count.index)}"
}
