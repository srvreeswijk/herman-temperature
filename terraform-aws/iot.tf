# The aws iot thing(s)
resource "aws_iot_thing" "herman_iot_thing" {
  for_each = toset(var.thing_ids)

  name = each.key
}

# A policy for the iot thing that allowes things inbound
resource "aws_iot_policy" "herman_policy" {
  name = "HermanIncomming"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iot:Connect",
        "iot:Subscribe"
      ],
      "Resource": "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:client/$${iot:ClientId}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iot:Publish"
      ],
      "Resource": "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/${var.mqtt_topic}"
    }
  ]
}
EOF
}

# Create an aws iot certificate
resource "aws_iot_certificate" "iot_cert" {
  for_each = toset(var.thing_ids)

  active = true
}

# Attach policy generated above to the aws iot thing(s)
resource "aws_iot_policy_attachment" "iot_policy_att" {
  for_each = toset(var.thing_ids)

  policy = aws_iot_policy.herman_policy.name
  target = aws_iot_certificate.iot_cert[each.key].arn
}


# Output certificate to /cert/{THING} folder
resource "local_file" "iot_cert_pem" {
  for_each = toset(var.thing_ids)

  content     = aws_iot_certificate.iot_cert[each.key].certificate_pem
  filename = "${path.module}/certs/${each.key}/${substr(aws_iot_certificate.iot_cert[each.key].id,0,12)}.pem.crt"
}

# Output private key to /cert/{THING} folder
resource "local_file" "iot_private_key" {
  for_each = toset(var.thing_ids)

  content     = aws_iot_certificate.iot_cert[each.key].private_key
  filename = "${path.module}/certs/${each.key}/${substr(aws_iot_certificate.iot_cert[each.key].id,0,12)}.private.key"
}

# Output public key to /cert/{THING} folder
resource "local_file" "iot_public_key" {
  for_each = toset(var.thing_ids)

  content     = aws_iot_certificate.iot_cert[each.key].public_key
  filename = "${path.module}/certs/${each.key}/${substr(aws_iot_certificate.iot_cert[each.key].id,0,12)}.public.key"
}

# Attach AWS iot cert generated above to the aws iot thing(s) 
resource "aws_iot_thing_principal_attachment" "iot_principal_att" {
  for_each = toset(var.thing_ids)

  principal = aws_iot_certificate.iot_cert[each.key].arn
  thing     = aws_iot_thing.herman_iot_thing[each.key].name
}

# IOT role to push metrics to CloudWatch
resource "aws_iot_topic_rule" "temp_rule" {
  name        = "hermanCloudWatchRule"
  description = "push metrics to CloudWatch for Herman"
  enabled     = true
  sql         = "SELECT * FROM '${var.mqtt_topic}'"
  sql_version = "2016-03-23"

  cloudwatch_metric {
    metric_name      = "$${location}"
    metric_namespace = "herman/temp"
    metric_unit      = "None"
    metric_value     = "$${temp}"
    role_arn         = aws_iam_role.iot_role.arn
  }

  cloudwatch_metric {
    metric_name      = "$${location}"
    metric_namespace = "herman/voltage"
    metric_unit      = "None"
    metric_value     = "$${voltage}"
    role_arn         = aws_iam_role.iot_role.arn
  }
}

resource "aws_iam_role" "iot_role" {
  name = "iot_cloudwatch_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "iot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iot_cloudwatch_policy" {
  name = "iot_cloudwatch_policy"
  role = aws_iam_role.iot_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "cloudwatch:PutMetricData",
        "Resource": [
            "*"
        ]
    }
}
EOF
}

# Export certificates and print output to the screen
# Get the aws iot endpoint to print out for reference
data "aws_iot_endpoint" "endpoint" {
    endpoint_type = "iot:Data-ATS"
}

# Output arn of iot thing(s) 
output "iot_endpoint" {
  value = data.aws_iot_endpoint.endpoint.endpoint_address
}