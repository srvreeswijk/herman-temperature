# group definition
resource "aws_iam_group" "herman_group" {
  name = "herman"
}

# For users to see the cloudwatch metrics and graphs
resource "aws_iam_policy" "herman_policy" {
  name        = "herman_policy"
  path        = "/"
  description = "Cloudwatch readonly for Herman group"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:*",
                "logs:*",
                "sns:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

# for now attach Cloudwatch read only access
resource "aws_iam_policy_attachment" "herman_policy_attachment" {
  name       = "herman_attach"
  groups     = ["${aws_iam_group.herman_group.name}"]
  policy_arn = aws_iam_policy.herman_policy.arn
}

resource "aws_iam_user" "Gerrit" {
  name = "Gerrit"
}

resource "aws_iam_group_membership" "herman_users" {
  name  = "herman_users"
  users = [
    "${aws_iam_user.Gerrit.name}"
  ]
  group = aws_iam_group.herman_group.name
}