resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "herman-koeling"

  dashboard_body = <<EOF
  {
      "widgets": [
          {
              "type": "metric",
              "x": 0,
              "y": 0,
              "width": 24,
              "height": 9,
              "properties": {
                  "metrics": [
                      [ "AWS/IoT", "Success", "ActionType", "Cloudwatch Metric", "RuleName", "cloudWatchKamer001", { "visible": false } ],
                      [ ".", "Failure", ".", ".", ".", ".", { "visible": false } ],
                      [ ".", "kamer1", { "stat": "Maximum" } ],
                      [ ".", "kamer2", { "stat": "Maximum" } ]
                  ],
                  "view": "timeSeries",
                  "stacked": false,
                  "region": "us-east-1",
                  "stat": "Average",
                  "period": 300,
                  "title": "Temperature",
                  "yAxis": {
                      "left": {
                          "label": "Celcius",
                          "showUnits": false,
                          "min": 19,
                          "max": 28
                      }
                  }
              }
          },
          {
              "type": "metric",
              "x": 0,
              "y": 9,
              "width": 24,
              "height": 6,
              "properties": {
                  "metrics": [
                      [ "AWS/IoT/voltage", "kamer2" ],
                      [ ".", "kamer1" ]
                  ],
                  "view": "timeSeries",
                  "stacked": false,
                  "region": "us-east-1",
                  "period": 300,
                  "title": "Voltage Battery",
                  "yAxis": {
                      "left": {
                          "showUnits": false,
                          "label": "Volt",
                          "min": 3,
                          "max": 4.2
                      }
                  },
                  "stat": "Average"
              }
          }
      ]
  }
  EOF
}