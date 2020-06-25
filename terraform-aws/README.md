# Setup and maintain AWS IoT for herman's stuff
bron: 
github: https://github.com/soracom-labs/soracom-beam-to-aws-iot-terraform

generic terraform docs: https://www.terraform.io/docs/configuration/functions/substr.html
aws iot terraform docs: https://www.terraform.io/docs/providers/aws/r/iot_certificate.html

## Terraform commands
```
terraform init
terraform apply
```

## Handmatige actie
Ga naar https://eu-central-1.console.aws.amazon.com/sns/v3/home?region=eu-central-1#/topics  
Klik op de email topic en voeg een subscription toe van het type email.  
Dit kan niet me terraform omdat een email subscription een bevestiging nodig heeft en dit kan terraform niet.  
Omdat het tegen het principe van terraform in gaat. 

Met terraform kan je een user aanmaken. Maar geen wachtwoord zetten. 
Dus voeg een user toe aan terraform, geef deze user via IAM console handmatig een wachtwoord.  
En laat de gebruiker dan zelf zijn wachtwoord resetten. 


# export AWS config for easy terraform creation

import syntax: `terraform import <type.name> <name_on_aws>`
type.name zijn zoals in de terraform code resource description ex. `resource "aws_cloudwatch_metric_alarm" "Temperatuur" {}`
Dit wordt dan dus `aws_cloudwatch_metric_alarm.Temperatuur`

## aws_cloudwatch_metric_alarm
```
terraform import aws_cloudwatch_metric_alarm.Temperatuur "Temperatuur te hoog"
```

## aws_sns_topic
De naam van het te importeren object moet in dit geval de volledige arn zijn.  
`arn:aws:sns:us-east-1:125035307346:Default_CloudWatch_Alarms_Topic`

```
terraform import aws_sns_topic.user_updates arn:aws:sns:us-east-1:125035307346:Default_CloudWatch_Alarms_Topic
```