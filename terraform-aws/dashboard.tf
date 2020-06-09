
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "herman-koeling"

  dashboard_body = templatefile("${path.module}/templates/widgets.tmpl", { things = var.thing_ids, AWS_REGION = "${var.AWS_REGION}"})
}

resource "aws_cloudwatch_metric_alarm" "Temperatuur" {
  for_each = toset(var.thing_ids)

  alarm_name                = "Temperatuur te hoog voor ${each.key}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = each.key
  namespace                 = "herman/temp"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = "23"
  alarm_description         = "Een alarm bij een te hoge temperatuur voor ${each.key}"
  treat_missing_data        = "missing"
  insufficient_data_actions = []
}
  #alarm_actions             = [
  #        - "arn:aws:sns:us-east-1:125035307346:Default_CloudWatch_Alarms_Topic",
  #      ]

# aws_sns_topic.user_updates must be replaced
resource "aws_sns_topic" "email-warning" {
  name   = "email_CloudWatch_Alarms"

  policy = <<EOF
{
  "Version" : "2008-10-17",
  "tags" : {},
  "Statement" : [
      {
          "Action" : [
              "SNS:GetTopicAttributes",
              "SNS:SetTopicAttributes",
              "SNS:AddPermission",
              "SNS:RemovePermission",
              "SNS:DeleteTopic",
              "SNS:Subscribe",
              "SNS:ListSubscriptionsByTopic",
              "SNS:Publish",
              "SNS:Receive"
          ],
          "Condition" : {
              "StringEquals" : {
                  "AWS:SourceOwner" : "125035307346"
            }
            },
          "Effect" : "Allow",
          "Principal" : {
              "AWS" : "*"
          },
          "Resource" : "arn:aws:sns:eu-central-1:125035307346:cloudwatch-warning",
          "Sid" : "__default_statement_ID"
      }
  ]
}
EOF
}





