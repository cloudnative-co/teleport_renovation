#=================================================
# EC2 Sub
resource "aws_instance" "sub" {
  count  = "${lookup(var.sub, "count")}"
  instance_type = "${lookup(var.sub, "instance_type")}"
  ami = "${lookup(var.ami_id, var.region)}"
  subnet_id = "${element(aws_subnet.public_sub.*.id, count.index)}"
  key_name = "${aws_key_pair.teleport.id}"
  iam_instance_profile = "${aws_iam_instance_profile.sub.name}"
  vpc_security_group_ids = [
    "${aws_security_group.common_sub.id}",
    "${aws_security_group.auth_sub.id}",
    "${aws_security_group.proxy_sub.id}",
    "${aws_security_group.bastion_sub.id}"
  ]
  root_block_device = {
    volume_type = "gp2"
    volume_size = "${lookup(var.sub, "volume_size")}"
  }
  tags = {
    Name = "${var.cluster_sub_name}-sub-${count.index+1}"
    Roles = "sub"
  }
}

# EIPの定義
resource "aws_eip" "sub" {
  count  = "${lookup(var.sub, "count")}"
  vpc = true
  instance = "${aws_instance.sub.*.id[count.index]}"
}

#=================================================
# EC2 Node
resource "aws_instance" "node_sub" {
  count  = "${lookup(var.node_sub, "count")}"
  instance_type = "${lookup(var.node_sub, "instance_type")}"
  ami = "${lookup(var.ami_id, var.region)}"
  subnet_id = "${element(aws_subnet.public_sub.*.id, count.index)}"
  key_name = "${aws_key_pair.teleport.id}"
  iam_instance_profile = "${aws_iam_instance_profile.sub_node.name}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.common_sub.id}",
  ]
  root_block_device = {
    volume_type = "gp2"
    volume_size = "${lookup(var.sub, "volume_size")}"
  }
  tags = {
    Name = "${var.cluster_sub_name}-sub-${count.index+1}"
    Roles = "sub"
  }
}
