resource "aws_route53_record" "sub" {
  zone_id = "${data.aws_route53_zone.teleport.zone_id}"
  name    = "${var.cluster_sub_name}.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_lb.sub.dns_name}"
    zone_id                = "${aws_lb.sub.zone_id}"
    evaluate_target_health = true
  }
}
