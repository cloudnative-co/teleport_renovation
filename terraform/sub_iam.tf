#=================================================
# Sub Role

resource "aws_iam_role" "sub" {
    name = "${var.cluster_main_name}-sub-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "sub" {
    name = "${var.cluster_main_name}-sub-profile"
    role = "${aws_iam_role.sub.name}"
}
resource "aws_iam_role_policy_attachment" "sub-ssm" {
    role = "${aws_iam_role.sub.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}
resource "aws_iam_role_policy_attachment" "sub-readonly" {
    role = "${aws_iam_role.sub.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "sub-route53" {
    role = "${aws_iam_role.sub.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}
resource "aws_iam_role_policy_attachment" "sub-s3" {
    role = "${aws_iam_role.sub.name}"
    policy_arn = "${aws_iam_policy.sub-s3.arn}"
}
resource "aws_iam_role_policy_attachment" "sub-dynamo" {
    role = "${aws_iam_role.sub.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_policy" "sub-s3" {
  name = "teleport-sub-s3-policy"
  path = "/"
  description = "teleport-sub-s3-policy"
  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": ["s3:ListBucket"],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.sub-certs.bucket}"]
     },
     {
       "Effect": "Allow",
       "Action": [
         "s3:PutObject",
         "s3:GetObject"
       ],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.sub-certs.bucket}/*"]
     }
   ]
 }
 EOF
}


#=================================================
# Node Role

resource "aws_iam_role" "sub_node" {
    name = "${var.cluster_main_name}-sub-node-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.allow-assume.json}"
}
resource "aws_iam_instance_profile" "sub_node" {
    name = "${var.cluster_main_name}-sub-node-profile"
    role = "${aws_iam_role.sub_node.name}"
}
resource "aws_iam_role_policy_attachment" "sub-node-ssm" {
    role = "${aws_iam_role.sub_node.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}
resource "aws_iam_role_policy_attachment" "sub-node-readonly" {
    role = "${aws_iam_role.sub_node.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
