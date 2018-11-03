#=================================================
# Common SG

resource "aws_security_group" "common_sub" {
    name = "common_sub"
    description = "common_sub"
    vpc_id = "${aws_vpc.teleport_sub.id}"
    tags {
        Name = "common_sub"
    }
}

resource "aws_security_group_rule" "common_sub_ingress_self" {
    security_group_id = "${aws_security_group.common_sub.id}"
    type = "ingress"
    protocol = "-1"
    from_port = 0
    to_port = 0
    self = true
}

resource "aws_security_group_rule" "common_sub_egress_all" {
    security_group_id = "${aws_security_group.common_sub.id}"
    type = "egress"
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
}

#=================================================
# Auth SG

resource "aws_security_group" "auth_sub" {
  name   = "auth_sub"
	vpc_id = "${aws_vpc.teleport_sub.id}"
  tags {
    Name = "auth_sub"
  }
}

resource "aws_security_group_rule" "auth_sub_ingress_allow_cidr_traffic" {
  type              = "ingress"
  from_port         = 3025
  to_port           = 3025
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.public_sub.*.cidr_block}"]
  security_group_id = "${aws_security_group.auth_sub.id}"
}

resource "aws_security_group_rule" "auth_sub_egress_allow_all_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.auth_sub.id}"
}

#=================================================
# Proxy SG

resource "aws_security_group" "proxy_sub" {
  name   = "proxy_sub"
	vpc_id = "${aws_vpc.teleport_sub.id}"
  tags {
    Name = "proxy_sub"
  }
}

resource "aws_security_group_rule" "proxy_sub_ingress_allow_proxy_sub" {
  type              = "ingress"
  from_port         = 3023
  to_port           = 3023
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.proxy_sub.id}"
}

resource "aws_security_group_rule" "proxy_sub_ingress_allow_web" {
  type              = "ingress"
  from_port         = 3080
  to_port           = 3080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.proxy_sub.id}"
}

resource "aws_security_group_rule" "proxy_sub_egress_allow_all_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.proxy_sub.id}"
}

#=================================================
# Bastion SG

resource "aws_security_group" "bastion_sub" {
  name   = "bastion_sub"
  vpc_id = "${aws_vpc.teleport_sub.id}"
  tags {
    Name = "bastion_sub"
  }
}

resource "aws_security_group_rule" "bastion_sub_ingress_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.ip_addresses_ssh}"]
  security_group_id = "${aws_security_group.bastion_sub.id}"
}

resource "aws_security_group_rule" "bastion_sub_egress_allow_all_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_sub.id}"
}
