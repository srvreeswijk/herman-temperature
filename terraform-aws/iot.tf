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
      "Resource": "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iot:Publish"
      ],
      "Resource": "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/herman"
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

# Get the aws iot endpoint to print out for reference
data "aws_iot_endpoint" "endpoint" {
    endpoint_type = "iot:Data-ATS"
}

# Output arn of iot thing(s) 
output "iot_endpoint" {
  value = data.aws_iot_endpoint.endpoint.endpoint_address
}