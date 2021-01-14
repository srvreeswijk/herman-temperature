
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "herman-koeling"

  dashboard_body = templatefile("${path.module}/templates/widgets.tmpl", { things = keys(local.things), AWS_REGION = "${var.AWS_REGION}"})
}

# Temperature alarms
resource "aws_cloudwatch_metric_alarm" "alarm" {
  for_each = local.things

  alarm_name                = "Temperatuur te hoog voor ${each.key}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  datapoints_to_alarm       = "2"
  metric_name               = each.key
  namespace                 = "herman/temp"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = each.value.treshold
  alarm_description         = "Een alarm bij een te hoge temperatuur voor ${each.key}"
  #treat_missing_data options: missing, ignore, breaching and notBreaching
  treat_missing_data        = "breaching"
  insufficient_data_actions = []
  alarm_actions             = []
}






