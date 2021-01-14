resource "aws_cloudwatch_event_rule" "temperature_alarm" {
  name        = "temperature_alarm"
  description = "Send a email when the temperature is too high."
  event_pattern = templatefile("${path.module}/templates/event_pattern.tmpl", { ALARM_ARN = values(aws_cloudwatch_metric_alarm.alarm)[*].arn })
}


resource "aws_cloudwatch_event_target" "send_warning_email" {
  rule      = aws_cloudwatch_event_rule.temperature_alarm.name
  target_id = "sendWaringEmail"
  arn       = aws_lambda_function.warning_lambda.arn
}
