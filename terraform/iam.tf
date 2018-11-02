#=================================================
# IAM定義

#=================================================
# AssumeRole
data "aws_iam_policy_document" "allow-assume" {
    statement {
        effect = "Allow"
        actions = [
            "sts:AssumeRole"
        ]
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

#=================================================
# Proxy Role
resource "aws_iam_role" "proxy" {
    name = "${var.cluster_name}-proxy-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "proxy" {
    name = "${var.cluster_name}-proxy-profile"
    role = "${aws_iam_role.proxy.name}"
}
resource "aws_iam_role_policy_attachment" "proxy-ssm" {
    role = "${aws_iam_role.proxy.name}"
		policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "proxy-s3" {
    role = "${aws_iam_role.proxy.name}"
		policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


#=================================================
# Auth Role

resource "aws_iam_role" "auth" {
    name = "${var.cluster_name}-auth-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "auth" {
    name = "${var.cluster_name}-auth-profile"
    role = "${aws_iam_role.auth.name}"
}
resource "aws_iam_role_policy_attachment" "auth-ssm" {
    role = "${aws_iam_role.auth.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "auth-s3" {
    role = "${aws_iam_role.auth.name}"
		policy_arn = "${aws_iam_policy.auth-s3.arn}"
}
resource "aws_iam_role_policy_attachment" "auth-dynamo" {
    role = "${aws_iam_role.auth.name}"
		policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

#=================================================
# Node Role

resource "aws_iam_role" "node" {
    name = "${var.cluster_name}-node-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "node" {
    name = "${var.cluster_name}-node-profile"
    role = "${aws_iam_role.node.name}"
}
resource "aws_iam_role_policy_attachment" "node-ssm" {
    role = "${aws_iam_role.auth.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
