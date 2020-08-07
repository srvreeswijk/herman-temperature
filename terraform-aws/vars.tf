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

locals {
  things = {
    "machinekamer" = { treshold = 50 },
    "koelcel-hal" = { treshold = 7 },
    "vriezer" = { treshold = -9 }
  }
}

# A list of SIM IMSI ids. For each id an aws iot thing will be created.
# Update this list with your names of sensors. 
variable "thing_ids" {
  type    = list(string)
  default = ["machinekamer", "koelcel-hal", "vriezer"]
  # Waarschuwing: in dashboard.tf bij module alarms komt dit lijstje nog een keer voor, met max temperatuur waarden. 
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

