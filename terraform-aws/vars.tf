variable "AWS_REGION" {
  type = string
  default = "eu-central-1"
}

# Update this variable with a cell phone number 
# that will receive the text messages
# Please include country code: ex. +18885555555
variable "phone_number" {
  type = string
  default = "+31625133230"
} 

# A list of sensor names and treshold values on which to send a alarm
locals {
  things = {
    "koelcel-voor" = { treshold = 7 },
    "koelcel-hal" = { treshold = 7 },
    "vriezer" = { treshold = -9 }
  }
}


variable "mqtt_topic" {
  type    = string
  default = "topic/herman"
}

variable "sns_email_topic" {
  type    = string
  default = "email_CloudWatch_Alarms"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

