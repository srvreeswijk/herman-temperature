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

# For Lambda functions to be able to send email through SES
resource "aws_iam_policy" "lambda_ses_policy" {
  name        = "lambda_ses_policy"
  path        = "/"
  description = "Allow Lambda functions to send email through SES"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# The IAM role belonging to the lambda_ses_policy
resource "aws_iam_role" "lambda_ses_role" {
    name               = "lambda_ses_role"
    path               = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Connect the IAM Lambda policy to the role
resource "aws_iam_role_policy_attachment" "lambda_ses_attachment" {
  role       = aws_iam_role.lambda_ses_role.name
  policy_arn = aws_iam_policy.lambda_ses_policy.arn
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