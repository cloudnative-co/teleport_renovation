resource "aws_s3_bucket" "main-certs" {
  bucket = "${var.domain}-${var.cluster_main_name}-certs"
  acl = "private"
}

resource "aws_s3_bucket" "sub-certs" {
  bucket = "${var.domain}-${var.cluster_sub_name}-certs"
  acl = "private"
}
