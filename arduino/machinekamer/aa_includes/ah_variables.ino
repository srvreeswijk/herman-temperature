// Update these with values suitable for your network.
const char* ssid = WIFI_SSID;
const char* password = WIFI_PASSWORD;
const char* AWS_endpoint = AWS_ENDPOINT;
const char* temperatureTopic = "topic/herman";
long slaapTijd = 5 * 60 * 1000000;             // Tijd in ms hoe lang de tijd moet zijn tussen 2 metingen. 1 sec = 1000000 us

const char* location = "machinekamer";    // De kamer of lokatie waar de sensor is geplaatst
float tempCorr = -0.37;              // Correctie waarde voor de gemeten temperatuur kamer1
float battCorr = 1.98;             // Correctie waarde om gemete waarde om te zetten in werkelijke batt voltage
// Onthoud dat de Wemos D1 mini ook nog een interne weerstand heeft die de voltage devider berekening verneukt. Dus gewoon meten met de wemos en dan de correctie waarde berekenen. 

// Most likely these need no change
long lastMsgTime = 0;
char msg[100];
int value = 0;

/*
 * v2.   Retry on MQTT post failure
 * v2.1  small fix
 * 
 */
