resource "aws_ses_email_identity" "sebas" {
  for_each = local.email
  email = each.value.email
}