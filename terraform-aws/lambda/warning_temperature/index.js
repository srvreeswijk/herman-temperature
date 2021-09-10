var aws = require("aws-sdk");
var ses = new aws.SES({ region: "eu-central-1" });
exports.handler = async function (event) {
  
  var time = new Date(event.detail.state.timestamp)
  if (event.detail.state.reason.includes('[Breaching]')){
    var subject = "GEEN DATA: " + " voor " + event.detail.configuration.metrics[0].metricStat.metric.name;
    var message = "Op " + time.toLocaleDateString('nl-NL', { timeZone: 'Europe/Amsterdam' }) + " om " + time.toLocaleTimeString('nl-NL', { timeZone: 'Europe/Amsterdam' }) +
                " is geconstateerd dat er al een tijdje geen meetwaarden meer binnenkomen.\n" +
                "Indien dit voor alle koelingen op het zelfde moment is, dan zou er een stroomstoring kunnen zijn. Of een wifi probleem." 
  } else {
    var subject = "ALARM: " + event.detail.alarmName;
    var message = "Op " + time.toLocaleDateString('nl-NL', { timeZone: 'Europe/Amsterdam' }) + " om " + time.toLocaleTimeString('nl-NL', { timeZone: 'Europe/Amsterdam' }) +
                  " is geconstateerd dat " + event.detail.configuration.metrics[0].metricStat.metric.name + " een te hoge temperatuur heeft.\n" 
                  //"\n\nDe technische details voor dit alarm staan hier onder." +
                  //"\nLet op dat de genoemde tijd in UTC is en niet gecorrigeerd voor de Nederlandse tijdzone.\n" +
                  //event.detail.state.reason;
                  //+ "\n\n" + JSON.stringify(event);
  }

  var params = {
    Destination: {
      ToAddresses: ["s.vreeswijk@gmail.com", "gerrit.jan.vreeswijk@gmail.com"],
    },
    Message: {
      Body: {
        Text: { Data: message },
      },
      Subject: { Data: subject },
    },
    Source: "alerts.slagerij@gmail.com",
  };
 
  return ses.sendEmail(params).promise()
};