
void reconnect() {
  if (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("testje")) {
      Serial.println("connected");
      Serial.print("connection status 0=connected: "); Serial.println(client.state());
    } else {
      Serial.print("MQTT connection failed, return code = "); Serial.print(client.state());
      char buf[256];
      espClient.getLastSSLError(buf,256);
      Serial.print("WiFiClientSecure SSL error: ");
      Serial.println(buf);
      // Wait 5 seconds before retrying
      Serial.println(" try again in 5 seconds");
      ESP.deepSleep(5 * 1000000);     // 5 seconds sleep
    }
  }
}

void load_certificates() {
  if (!SPIFFS.begin()) {
    Serial.println("Failed to mount file system");
    return;
  }
  // Load certificate
  File cert = SPIFFS.open("/cert.der", "r"); 
  delay(200);
  espClient.loadCertificate(cert);
  
  // Load private key
  File private_key = SPIFFS.open("/private.der", "r"); 
  delay(200);
  espClient.loadPrivateKey(private_key);
  
  // Load CA
  File ca = SPIFFS.open("/ca.der", "r"); 
  delay(200);
  espClient.loadCACert(ca);
}

void send_message() {
  if (!client.connected()) {
      Serial.println("client is not connected, so reconnect");
      reconnect();
    }
  client.loop();
  float temp=read_temp();
  float voltage=read_batt();
  long  rssi=getRssi();
  
  snprintf (msg, 100, "{\"temp\": %4.1f, \"location\": \"%s\", \"voltage\": %4.1f, \"rssi\": %ld}", temp, location, voltage, rssi);
  Serial.print("Publish message: ");
  Serial.println(msg);
  bool publishSuccess = client.publish(temperatureTopic, msg);
  if (! publishSuccess) {
    Serial.println("MQTT publish failed, retry in 10 seconds");
    ESP.deepSleep(10 * 1000000);     // 10 seconds sleep
  }
  Serial.print("MQTT publish has "); 
  if (publishSuccess){
    Serial.println("succeded");
  } else {
    Serial.println("**failed**");
  }
  Serial.print("Free Heap: "); Serial.println(ESP.getFreeHeap()); //Low heap can cause problems
}

void blink_led() {
  digitalWrite(LED_BUILTIN, HIGH); // turn the LED on (HIGH is the voltage level)
  delay(1000); // wait for a second
  digitalWrite(LED_BUILTIN, LOW); // turn the LED off by making the voltage LOW
  delay(1000); // wait for a second
}

void setup() {
  Serial.begin(115200);
  Serial.setDebugOutput(false);
  pinMode(LED_BUILTIN, OUTPUT);
  
  setup_wifi();
  Serial.print("Wifi Signal Strength: "); Serial.println(getRssi());
  delay(500);
  
  load_certificates();
  sensors.begin();
  send_message();
  Serial.println("Disconnect MQTT client");
  client.disconnect();
  blink_led();
  Serial.print("All done, see you in ");
  Serial.print(slaapTijd / (60 * 1000000));
  Serial.println(" minutes.");
  ESP.deepSleep(slaapTijd);
}
