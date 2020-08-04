WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}

WiFiClientSecure espClient;
PubSubClient client(AWS_endpoint, 8883, callback, espClient); //set MQTT port number to 8883 as per //standard

long getRssi() {
  long rssi = WiFi.RSSI();
  return rssi;
}

void setup_wifi() {
  delay(10);
  // We start by connecting to a WiFi network
  espClient.setBufferSizes(512, 512);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  for (int i = 0; i <= 120; i++) {
    if (WiFi.status() != WL_CONNECTED) {
      Serial.print(".");
      delay(500);
    } else {
      break;
    }
  }
  
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WIFI connection failed, retry in 10 seconds");
    ESP.deepSleep(10 * 1000000);     // 10 seconds sleep
  }
  
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  
  timeClient.begin();
  while(!timeClient.update()){
    timeClient.forceUpdate();
  }
  
  espClient.setX509Time(timeClient.getEpochTime());
}
