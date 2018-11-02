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
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.certs.bucket}"]
     },
     {
       "Effect": "Allow",
       "Action": [
         "s3:PutObject",
         "s3:GetObject"
       ],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.certs.bucket}/*"]
     }
   ]
 }
 EOF
}
