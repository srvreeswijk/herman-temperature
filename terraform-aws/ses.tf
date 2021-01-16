resource "aws_ses_email_identity" "email_ontvangers" {
  for_each = local.email
  email = each.value.email
}