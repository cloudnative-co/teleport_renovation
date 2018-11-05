
output "teleport_auth_server_addr" {
  value = "${aws_route53_record.auth.name}"
}

output "teleport_proxy_domain" {
  value = "${aws_route53_record.proxy.name}"
}

output "teleport_sub_domain" {
  value = "${aws_route53_record.sub.name}"
}

output "teleport_cluster_name" {
  value = "${var.cluster_main_name}"
}

output "teleport_cluster_sub_name" {
  value = "${var.cluster_sub_name}"
}

output "teleport_region" {
  value = "${var.region}"
}

output "teleport_bucket_main" {
  value = "${aws_s3_bucket.main-certs.id}"
}

output "teleport_bucket_sub" {
  value = "${aws_s3_bucket.sub-certs.id}"
}
