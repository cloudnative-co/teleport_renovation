#=================================================
# キーペア
resource "aws_key_pair" "teleport" {
    key_name = "${var.cluster_main_name}_${var.region}"
    public_key = "${var.public_key}"
}
