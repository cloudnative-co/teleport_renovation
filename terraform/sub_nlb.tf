#=================================================
# Auth Proxy NLB

resource "aws_lb" "sub" {
  name            = "${var.cluster_sub_name}-sub"
  internal        = true
	subnets         = ["${aws_subnet.public_sub.*.id}"]
  load_balancer_type = "network"
  idle_timeout    = 60
	enable_cross_zone_load_balancing = "true"

  tags {
    Name = "${var.cluster_sub_name}-auth-sub-lb"
  }
}

resource "aws_lb_target_group" "auth_sub" {
  name     = "${var.cluster_sub_name}-auth"
  port     = 3025
  vpc_id   = "${aws_vpc.teleport_sub.id}"
  protocol = "TCP"
	deregistration_delay = 30
}

resource "aws_lb_listener" "auth_sub" {
  load_balancer_arn = "${aws_lb.sub.arn}"
  port              = "3025"
  protocol = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.auth_sub.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "auth_sub" {
  count  = "${lookup(var.sub, "count")}"
  target_group_arn = "${aws_lb_target_group.auth_sub.arn}"
  target_id = "${element(aws_instance.sub.*.id, count.index)}"
  port = 3025
}

resource "aws_lb_target_group" "proxy_sub" {
  name     = "${var.cluster_sub_name}-proxy"
  port     = 3023
  vpc_id   = "${aws_vpc.teleport_sub.id}"
  protocol = "TCP"
	deregistration_delay = 30
}

resource "aws_lb_listener" "proxy_sub" {
  load_balancer_arn = "${aws_lb.sub.arn}"
  port              = "3023"
  protocol = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxy_sub.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "proxy_sub" {
  count  = "${lookup(var.sub, "count")}"
  target_group_arn = "${aws_lb_target_group.proxy_sub.arn}"
  target_id = "${element(aws_instance.sub.*.id, count.index)}"
  port = 3023
}

# Web Proxy
resource "aws_lb_target_group" "proxy_sub_web" {
  name     = "${var.cluster_sub_name}-proxy-web"
  port     = 3080
  vpc_id   = "${aws_vpc.teleport_sub.id}"
  protocol = "TCP"
	deregistration_delay = 30
}

resource "aws_lb_listener" "proxy_sub_web" {
  load_balancer_arn = "${aws_lb.sub.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxy_sub_web.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "proxy_sub_web" {
  count  = "${lookup(var.sub, "count")}"
  target_group_arn = "${aws_lb_target_group.proxy_sub_web.arn}"
  target_id = "${element(aws_instance.sub.*.id, count.index)}"
  port = 3080
}
