
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "herman-koeling"

  dashboard_body = templatefile("${path.module}/templates/widgets.tmpl", { things = ["kamer1", "kamer2"], AWS_REGION = "${var.AWS_REGION}"})
}
