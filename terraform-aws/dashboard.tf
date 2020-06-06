
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "herman-koeling"

  dashboard_body = templatefile("${path.module}/templates/widgets.tmpl", { things = var.thing_ids, AWS_REGION = "${var.AWS_REGION}"})
}
