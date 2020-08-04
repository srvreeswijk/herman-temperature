
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "herman-koeling"

  dashboard_body = templatefile("${path.module}/templates/widgets.tmpl", { things = var.thing_ids, AWS_REGION = "${var.AWS_REGION}"})
}

# Hier moet het alarm komen

module "alarms" {
  source = "./modules/alarm"

  things = {
    "machinekamer" = {
        name      = "machinekamer",
        treshold = 40,
        snsTopic = "${aws_sns_topic.email-warning.arn}"
    },
    "koelcel-hal" = {
        name      = "koelcel-hal",
        treshold  = 7,
        snsTopic = "${aws_sns_topic.email-warning.arn}"
    },
    "vriezer" = {
        name      = "vriezer",
        treshold  = -9,
        snsTopic = "${aws_sns_topic.email-warning.arn}"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "Battery" {
  for_each = toset(var.thing_ids)

  alarm_name                = "Accu spanning voor ${each.key} is te laag"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  datapoints_to_alarm       = "2"
  metric_name               = each.key
  namespace                 = "herman/voltage"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = "3.1"
  alarm_description         = "Een alarm bij een te lage voltage voor de accu van ${each.key}"
  treat_missing_data        = "missing"
  insufficient_data_actions = []
  alarm_actions             = [
          "${aws_sns_topic.email-warning.arn}",
        ]
}

# aws_sns_topic.user_updates must be replaced
resource "aws_sns_topic" "email-warning" {
  name   = var.sns_email_topic

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
          "Resource" : "arn:aws:sns:eu-central-1:125035307346:${var.sns_email_topic}",
          "Sid" : "__default_statement_ID"
      }
  ]
}
EOF
}





