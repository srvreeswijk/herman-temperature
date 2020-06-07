
void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    //if (client.connect("125035307346")) {
    if (client.connect("testje")) {
      Serial.println("connected");
      Serial.print("connection status 0=connected: ");
      Serial.println(client.state());
      // Once connected, publish an announcement...
      //Serial.print("publish result: ");
      //Serial.println(client.publish("outTopic", "hello world"));
      //Serial.print("connection status after publish: ");
      //Serial.println(client.state());
      // ... and resubscribe
      //Serial.print("subscribe result: ");
      //Serial.println(client.subscribe("inTopic"));
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      
      char buf[256];
      espClient.getLastSSLError(buf,256);
      Serial.print("WiFiClientSecure SSL error: ");
      Serial.println(buf);
      
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void send_message() {
  if (!client.connected()) {
      Serial.println("client is not connected, so reconnect");
      reconnect();
    }
  client.loop();
  float temp=read_temp();
  float voltage=read_batt();
  
  snprintf (msg, 75, "{\"temp\": %4.1f, \"location\": \"%s\", \"voltage\": %4.1f}", temp, location, voltage);
  Serial.print("Publish message: ");
  Serial.println(msg);
  bool publishResult = client.publish(temperatureTopic, msg);
  Serial.print("publish result (0=failed 1=success) :"); Serial.println(publishResult);
  Serial.print("Heap: "); Serial.println(ESP.getFreeHeap()); //Low heap can cause problems
  
  digitalWrite(LED_BUILTIN, HIGH); // turn the LED on (HIGH is the voltage level)
  delay(1000); // wait for a second
  digitalWrite(LED_BUILTIN, LOW); // turn the LED off by making the voltage LOW
  delay(1000); // wait for a second
}

void setup() {
  Serial.begin(115200);
  Serial.setDebugOutput(true);
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  
  setup_wifi();
  delay(1000);
  if (!SPIFFS.begin()) {
    Serial.println("Failed to mount file system");
    return;
  }

  // Load certificate file
  File cert = SPIFFS.open("/cert.der", "r"); //replace cert.crt eith your uploaded file name
  if (!cert) {
  Serial.println("Failed to open cert file");
  }
  else
  Serial.println("Success to open cert file");
  
  delay(1000);
  
  if (espClient.loadCertificate(cert))
  Serial.println("cert loaded");
  else
  Serial.println("cert not loaded");
  
  // Load private key file
  File private_key = SPIFFS.open("/private.der", "r"); //replace private eith your uploaded file name
  if (!private_key) {
  Serial.println("Failed to open private cert file");
  }
  else
  Serial.println("Success to open private cert file");
  
  delay(1000);
  
  if (espClient.loadPrivateKey(private_key))
  Serial.println("private key loaded");
  else
  Serial.println("private key not loaded");
  
  // Load CA file
  File ca = SPIFFS.open("/ca.der", "r"); //replace ca eith your uploaded file name
  if (!ca) {
  Serial.println("Failed to open ca ");
  }
  else
  Serial.println("Success to open ca");
  
  delay(1000);
  
  if(espClient.loadCACert(ca))
  Serial.println("ca loaded");
  else
  Serial.println("ca failed");
  
  Serial.print("Heap: "); Serial.println(ESP.getFreeHeap());

  // Initialize the temp sensor
  sensors.begin();

  // Send measurements and go back to sleep
  send_message();
  ESP.deepSleep(slaapTijd);
}
