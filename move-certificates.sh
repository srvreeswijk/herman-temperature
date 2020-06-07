#!/bin/bash

sourcePath=terraform-aws/certs
destPath=terraform-aws/certs

for dir in $sourcePath/*/ ; do
  thing=$(basename $dir)
  echo $thing
  openssl x509 -in $sourcePath/$thing/*.pem.crt -out $destPath/$thing/cert.der -outform DER
  openssl rsa -in $sourcePath/$thing/*.private.key -out $destPath/$thing/private.der -outform DER
  cp $sourcePath/ca.der $destPath/$thing/ca.der
done
