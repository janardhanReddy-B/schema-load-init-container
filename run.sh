#!/bin/bash

set -x

while true ; do
  if [ -f /data/params ]; then
    echo "### Parameters"
    cat /data/params
    source /data/params
    break
  else
    echo $(date) - Waiting for Parameters
    sleep 5
  fi
done

mkdir /app
cd /app
git clone https://github.com/raghudevopsb73/catalogue
cd catalogue/schema

if [ "mongo" == "mongo" ]; then
  curl -s -L https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -o /app/rds-combined-ca-bundle.pem
  mongo --ssl --host docdb-prod.cluster-cajpnbnycbmh.us-east-1.docdb.amazonaws.com:27017 --sslCAFile /app/rds-combined-ca-bundle.pem --username roboshop --password roboshop123 <catalogue.js
elif [ "mysql" == "mysql" ]; then
  echo show databases | mysql -h rds-prod.cluster-cajpnbnycbmh.us-east-1.rds.amazonaws.com -uroboshop -proboshop123 | grep cities
  if [ $? -ne 0 ]; then
    mysql -h rds-prod.cluster-cajpnbnycbmh.us-east-1.rds.amazonaws.com -uroboshop -proboshop123 <shipping.sql
  fi
else
  echo Invalid Schema Input
  exit 1
fi