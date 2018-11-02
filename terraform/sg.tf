#=================================================
# Common SG

resource "aws_security_group" "common" {
    name = "common"
    description = "common"
    vpc_id = "${aws_vpc.teleport.id}"
    tags {
        Name = "common"
    }
}

resource "aws_security_group_rule" "common_ingress_self" {
    security_group_id = "${aws_security_group.common.id}"
    type = "ingress"
    protocol = "-1"
    from_port = 0
    to_port = 0
    self = true
}

resource "aws_security_group_rule" "common_egress_all" {
    security_group_id = "${aws_security_group.common.id}"
    type = "egress"
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
}

#=================================================
# Auth SG

resource "aws_security_group" "auth" {
  name   = "auth"
	vpc_id = "${aws_vpc.teleport.id}"
  tags {
    Name = "auth"
  }
}

resource "aws_security_group_rule" "auth_ingress_allow_cidr_traffic" {
  type              = "ingress"
  from_port         = 3025
  to_port           = 3025
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.public.*.cidr_block}"]
  security_group_id = "${aws_security_group.auth.id}"
}

resource "aws_security_group_rule" "auth_ingress_allow_node_cidr_traffic" {
  type              = "ingress"
  from_port         = 3025
  to_port           = 3025
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.protected.*.cidr_block}"]
  security_group_id = "${aws_security_group.auth.id}"
}

resource "aws_security_group_rule" "auth_egress_allow_all_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.auth.id}"
}

#=================================================
# Proxy SG

resource "aws_security_group" "proxy" {
  name   = "proxy"
	vpc_id = "${aws_vpc.teleport.id}"
  tags {
    Name = "proxy"
  }
}

resource "aws_security_group_rule" "proxy_ingress_allow_proxy" {
  type              = "ingress"
  from_port         = 3023
  to_port           = 3023
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.proxy.id}"
}

resource "aws_security_group_rule" "proxy_ingress_allow_web" {
  type              = "ingress"
  from_port         = 3080
  to_port           = 3080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.proxy.id}"
}

resource "aws_security_group_rule" "proxy_egress_allow_all_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.proxy.id}"
}
