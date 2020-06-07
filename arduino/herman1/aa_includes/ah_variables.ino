// Update these with values suitable for your network.
const char* ssid = "H369A35ADD0";
const char* password = WIFI_PASSWORD;
// Enter here the AWS MQTT broker id for your thing
// Look here: https://console.aws.amazon.com/iot/home?region=us-east-1#/thing/temp001      Where temp001 is your thing name, and look for HTTPS endpoint under the menu item Interact. 
const char* AWS_endpoint = AWS_ENDPOINT; //MQTT HTTPS broker ip
const char* temperatureTopic = "topic/herman";
long slaapTijd = 5 * 60 * 1000000;             // Tijd in ms hoe lang de tijd moet zijn tussen 2 metingen. 1 sec = 1000000 us

const char* location = "herman1";    // De kamer of lokatie waar de sensor is geplaatst
float tempCorr = -0.6;              // Correctie waarde voor de gemeten temperatuur kamer1
float battCorr = 2;             // Correctie waarde om gemete waarde om te zetten in werkelijke batt voltage
// Onthoud dat de Wemos D1 mini ook nog een interne weerstand heeft die de voltage devider berekening verneukt. Dus gewoon meten met de wemos en dan de correctie waarde berekenen. 

// Most likely these need no change
long lastMsgTime = 0;
char msg[75];
int value = 0;
