resource "aws_cloudwatch_metric_alarm" "alarm" {
  for_each = var.things
  #for_each = toset(var.thing_ids)

  alarm_name                = "Temperatuur te hoog voor ${each.value.name}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  datapoints_to_alarm       = "2"
  metric_name               = each.value.name
  namespace                 = "herman/temp"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = each.value.treshold
  alarm_description         = "Een alarm bij een te hoge temperatuur voor ${each.value.name}"
  treat_missing_data        = "missing"
  insufficient_data_actions = []
  alarm_actions             = [
          "${each.value.snsTopic}",
        ]
}