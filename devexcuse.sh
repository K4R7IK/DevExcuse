#!/usr/bin/env bash

#Defining location
DATAFILE=$HOME/.config/excuse.json

if [[ ! -f "$DATAFILE" ]]; then
  echo "Installing Excuse database..."
  curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/excuse.json -o $DATAFILE
fi

#Checking dependencies
if ! command -v jq &>/dev/null; then
  echo "jq is not installed."
  exit 1
fi

get_random_excuse(){
 jq -r '.[] | select(.text_en) | .text_en' $DATAFILE | shuf -n 1
}

get_random_excuse
