// #####################       read_temp       #########################################
float read_temp(void) {
  // make some initial measurements to fix false readings
  for (int i = 0; i <= 4; i++) {
    sensors.requestTemperatures(); // Send the command to get temperatures
    delay(500);
  }
  sensors.requestTemperatures(); // Send the command to get temperatures
  float temp = sensors.getTempCByIndex(0) + tempCorr;
  return temp;
}
