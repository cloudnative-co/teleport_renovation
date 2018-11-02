#=================================================
# Auth NLB

resource "aws_lb" "auth" {
  name            = "${var.cluster_name}-auth"
  internal        = true
  subnets         = ["${aws_subnet.public.*.id}"]
  load_balancer_type = "network"
  idle_timeout    = 60
	enable_cross_zone_load_balancing = "true"

  tags {
    Name = "${var.cluster_name}-auth-lb"
  }
}

resource "aws_lb_target_group" "auth" {
  name     = "${var.cluster_name}-auth"
  port     = 3025
  vpc_id   = "${aws_vpc.teleport.id}"
  protocol = "TCP"
	deregistration_delay = 30
}

resource "aws_lb_listener" "auth" {
  load_balancer_arn = "${aws_lb.auth.arn}"
  port              = "3025"
  protocol = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.auth.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "auth" {
  count  = "${lookup(var.auth, "count")}"
  target_group_arn = "${aws_lb_target_group.auth.arn}"
  target_id = "${element(aws_instance.auth.*.id, count.index)}"
  port = 3025
}

#=================================================
# Proxy NLB

# Proxy
resource "aws_lb" "proxy" {
  name            = "${var.cluster_name}-proxy"
  internal        = false
  subnets         = ["${aws_subnet.public.*.id}"]
  load_balancer_type = "network"
  idle_timeout    = 60
	enable_cross_zone_load_balancing = "true"

  tags {
    Name = "${var.cluster_name}-proxy-lb"
  }
}

resource "aws_lb_target_group" "proxy" {
  name     = "${var.cluster_name}-proxy"
  port     = 3023
  vpc_id   = "${aws_vpc.teleport.id}"
  protocol = "TCP"
	deregistration_delay = 30
}

resource "aws_lb_listener" "proxy" {
  load_balancer_arn = "${aws_lb.proxy.arn}"
  port              = "3023"
  protocol = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxy.arn}"
    type             = "forward"
  }
}

# Web Proxy
resource "aws_lb_target_group" "proxy_web" {
  name     = "${var.cluster_name}-proxy-web"
  port     = 3080
  vpc_id   = "${aws_vpc.teleport.id}"
  protocol = "TCP"
	deregistration_delay = 30
}

resource "aws_lb_listener" "proxy_web" {
  load_balancer_arn = "${aws_lb.proxy.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxy_web.arn}"
    type             = "forward"
  }
}
