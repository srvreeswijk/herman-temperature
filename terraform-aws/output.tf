output "alarm" {
 description = "List of alarms"
 value       = values(aws_cloudwatch_metric_alarm.alarm)[*].arn
}