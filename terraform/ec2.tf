#=================================================
# EC2 Auth
resource "aws_instance" "auth" {
  count  = "${lookup(var.auth, "count")}"
  instance_type = "${lookup(var.auth, "instance_type")}"
	ami = "${lookup(var.ami_id, var.region)}"
  subnet_id = "${element(aws_subnet.protected.*.id, count.index)}"
  key_name = "${aws_key_pair.teleport.id}"
	iam_instance_profile = "${aws_iam_instance_profile.auth.name}"
  vpc_security_group_ids = [
    "${aws_security_group.common.id}",
    "${aws_security_group.auth.id}",
  ]
  root_block_device = {
    volume_type = "gp2"
		volume_size = "${lookup(var.auth, "volume_size")}"
  }
  tags = {
    Name = "${var.cluster_name}-auth-${count.index+1}"
    Roles = "auth"
  }
}

#=================================================
# EC2 Proxy
resource "aws_instance" "proxy" {
  count  = "${lookup(var.proxy, "count")}"
  instance_type = "${lookup(var.proxy, "instance_type")}"
  ami = "${lookup(var.ami_id, var.region)}"
  subnet_id = "${element(aws_subnet.protected.*.id, count.index)}"
  key_name = "${aws_key_pair.teleport.id}"
  iam_instance_profile = "${aws_iam_instance_profile.proxy.name}"
  vpc_security_group_ids = [
    "${aws_security_group.common.id}",
    "${aws_security_group.proxy.id}",
  ]
  root_block_device = {
    volume_type = "gp2"
    volume_size = "${lookup(var.proxy, "volume_size")}"
  }
  tags = {
    Name = "${var.cluster_name}-proxy-${count.index+1}"
    Roles = "proxy"
  }
}

#=================================================
# EC2 Node
resource "aws_instance" "node" {
  count  = "${lookup(var.node, "count")}"
  instance_type = "${lookup(var.node, "instance_type")}"
  ami = "${lookup(var.ami_id, var.region)}"
  subnet_id = "${element(aws_subnet.protected.*.id, count.index)}"
  key_name = "${aws_key_pair.teleport.id}"
  iam_instance_profile = "${aws_iam_instance_profile.node.name}"
  vpc_security_group_ids = [
    "${aws_security_group.common.id}"
  ]
  root_block_device = {
    volume_type = "gp2"
    volume_size = "${lookup(var.node, "volume_size")}"
  }
  tags = {
    Name = "${var.cluster_name}-node-${count.index+1}"
    Roles = "node"
  }
}
