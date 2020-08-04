// #####################       read_battery_voltage     #########################################
float read_batt(void) {
  int battValue = analogRead(A0);
  float voltage = (battValue * (3.2 / 1023.0)) * battCorr;   //3.2 = max voltage by full battery, battCorr is voltage devider correction to real battery value
  return voltage;
}
