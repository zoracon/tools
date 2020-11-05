#!/bin/bash
# weather--Gets the weather for a specific region or ZIP code.

if [ $# -ne 1 ]; then
  echo "Usage: $0 <zipcode>"
  exit 1
fi

apikey="[whatever your key is]"

weather=`curl -s \
    "https://api.openweathermap.org/data/2.5/weather?zip=$1,us&appid=$apikey&mode=xml&units=imperial"`
state=`xmllint --xpath \
     string\(current/weather/@value\) \
     <(echo $weather)`
zip=`xmllint --xpath \
     string\(current/city/@name\) \
     <(echo $weather)`
current=`xmllint --xpath \
     string\(current/temperature/@value\) \
     <(echo $weather)`

echo " In "$zip", current temp is "$current" F and "$state" outside."
