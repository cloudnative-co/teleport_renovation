resource "aws_s3_bucket" "certs" {
  bucket = "${var.domain}-certs"
  acl = "private"
}
