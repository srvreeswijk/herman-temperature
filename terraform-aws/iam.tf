# group definition
resource "aws_iam_group" "herman_group" {
  name = "herman"
}

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
                "cloudwatch:GetDashboard"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:cloudwatch::125035307346:dashboard/herman-koeling",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": "eu-central-1"
                }
            }
        },
        {
            "Action": [
                "cloudwatch:getMetricData",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListDashboards"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": "eu-central-1"
                }
            }
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