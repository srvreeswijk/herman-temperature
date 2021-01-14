data "archive_file" "warning_lambda_zip" {
    type          = "zip"
    source_file   = "lambda/warning_temperature/index.js"
    output_path   = "warning_lambda.zip"
}

resource "aws_lambda_function" "warning_lambda" {
  filename         = "warning_lambda.zip"
  function_name    = "send_warning_email"
  role             = aws_iam_role.lambda_ses_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.warning_lambda_zip.output_base64sha256
  runtime          = "nodejs12.x"
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

# Add trigger to labda that allows the cloudwatch event_rule to trigger the lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.warning_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.temperature_alarm.arn
}