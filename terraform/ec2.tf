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
    Name = "${var.cluster_main_name}-auth-${count.index+1}"
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
    Name = "${var.cluster_main_name}-proxy-${count.index+1}"
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
    Name = "${var.cluster_main_name}-node-${count.index+1}"
    Roles = "node"
  }
}

#=================================================
# EC2 Bastion
resource "aws_instance" "bastion" {
  count  = "${lookup(var.bastion, "count")}"
  instance_type = "${lookup(var.bastion, "instance_type")}"
  ami = "${lookup(var.ami_id, var.region)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  key_name = "${aws_key_pair.teleport.id}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"
  vpc_security_group_ids = [
    "${aws_security_group.common.id}",
    "${aws_security_group.bastion.id}"
  ]
  root_block_device = {
    volume_type = "gp2"
    volume_size = "${lookup(var.bastion, "volume_size")}"
  }
  tags = {
    Name = "${var.cluster_main_name}-bastion-${count.index+1}"
    Roles = "bastion"
  }
}

# EIPの定義
resource "aws_eip" "bastion" {
  count  = "${lookup(var.bastion, "count")}"
  vpc = true
  instance = "${aws_instance.bastion.*.id[count.index]}"
}
