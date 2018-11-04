resource "aws_route53_record" "sub" {
	count  = "${lookup(var.sub, "count")}"
  zone_id = "${data.aws_route53_zone.teleport.zone_id}"
  name    = "${var.cluster_sub_name}.${var.domain}"
	ttl = 300
  type    = "A"
	records = ["${aws_eip.sub.*.public_ip[count.index]}"]
}
