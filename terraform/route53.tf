data "aws_route53_zone" "teleport" {
  name = "${var.domain}"
}

resource "aws_route53_record" "proxy" {
  zone_id = "${data.aws_route53_zone.teleport.zone_id}"
  name    = "${var.cluster_main_name}-proxy.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_lb.proxy.dns_name}"
    zone_id                = "${aws_lb.proxy.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "auth" {
  zone_id = "${data.aws_route53_zone.teleport.zone_id}"
  name    = "${var.cluster_main_name}-auth.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_lb.auth.dns_name}"
    zone_id                = "${aws_lb.auth.zone_id}"
    evaluate_target_health = true
  }
}
