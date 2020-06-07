Steps

1. Copy the arduino code from a sensor and delete the files from the data directory within the arduino code. 
2. Open the ah_variables.ino file and change the needed parameters. like sensor name, aws endpoint, sensor calibration etc. 
3. Add the sensor to the terraform variables file
4. Run the terraform code
5. run the move-certificates.sh script. 
   This will move the by terraform created certificates from terraform/certs to the arduino/sensor... data directory
6. Upload the certificates with arduino to the Wemos D1 board
7. Upload the arduino code to the Wemos D1 board. 
8. Calibrate the temp sensor and the battery voltage reading. And upload the changes to the Wemos. 


Converting PEM to DER format: (On Windowns you should download openssl first)
```
$ openssl x509 -in aaaaaaaaa-certificate.pem.crt.txt -out cert.der -outform DER 
$ openssl rsa -in aaaaaaaaaa-private.pem.key -out private.der -outform DER
```