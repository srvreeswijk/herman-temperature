var aws = require("aws-sdk");
var ses = new aws.SES({ region: "eu-central-1" });
exports.handler = async function (event) {
  
  var time = new Date(event.detail.state.timestamp)
  var subject = "OK: " + " voor " + event.detail.configuration.metrics[0].metricStat.metric.name;
  var message = "Op " + time.toLocaleDateString('nl-NL', { timeZone: 'Europe/Amsterdam' }) + " om " + time.toLocaleTimeString('nl-NL', { timeZone: 'Europe/Amsterdam' }) +
              " zijn alle waarschuwingen voor " + event.detail.configuration.metrics[0].metricStat.metric.name + " weer binnen de norm.\n";

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
    Source: "s.vreeswijk@gmail.com",
  };
 
  return ses.sendEmail(params).promise()
};