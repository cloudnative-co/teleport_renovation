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
    name = "${var.cluster_main_name}-proxy-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "proxy" {
    name = "${var.cluster_main_name}-proxy-profile"
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
    name = "${var.cluster_main_name}-auth-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "auth" {
    name = "${var.cluster_main_name}-auth-profile"
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
resource "aws_iam_policy" "auth-s3" {
  name = "teleport-auth-s3-policy"
  path = "/"
  description = "teleport-auth-s3-policy"
  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": ["s3:ListBucket"],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.main-certs.bucket}"]
     },
     {
       "Effect": "Allow",
       "Action": [
         "s3:PutObject",
         "s3:GetObject"
       ],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.main-certs.bucket}/*"]
     }
   ]
 }
 EOF
}

#=================================================
# Node Role

resource "aws_iam_role" "node" {
    name = "${var.cluster_main_name}-node-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "node" {
    name = "${var.cluster_main_name}-node-profile"
    role = "${aws_iam_role.node.name}"
}
resource "aws_iam_role_policy_attachment" "node-ssm" {
    role = "${aws_iam_role.auth.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

#=================================================
# Basiton Role

resource "aws_iam_role" "bastion" {
    name = "${var.cluster_main_name}-bastion-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "bastion" {
    name = "${var.cluster_main_name}-bastion-profile"
    role = "${aws_iam_role.bastion.name}"
}
resource "aws_iam_role_policy_attachment" "bastion-ssm" {
    role = "${aws_iam_role.auth.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

