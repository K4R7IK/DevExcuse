#!/usr/bin/env bash

API_URL="https://api.devexcus.es/"
DATA_FILE="$HOME/.config/devExcuse.json"

# dependencies: curl, jq checking if the dependencies are installed.
if ! command -v curl &>/dev/null; then
  echo "curl is not installed."
  exit 1
elif ! command -v jq &>/dev/null; then
  echo "jq is not installed."
  exit 1
fi

# if the file doesn't exist, create it.
if [[ ! -f "$DATA_FILE" ]]; then
  touch "$DATA_FILE"
fi

# Checks for duplicate id in the file.
check_id() {
  grep -q "\"id\": $1" "$DATA_FILE" &>/dev/null
}

# Add excuse to the file.
add_excuse() {
  echo "$1" >> "$DATA_FILE"
}

# Generate random excuse from the file.
get_random_excuse() {
  random_line=$(shuf -n 1 "$DATA_FILE" | jq -r '.text')
  echo "$random_line"
}

# Requesting the response and filtering the status code and response body.
HTTP_RES=$(curl -s -w "%{http_code}" "$API_URL")
HTTP_STATUS=${HTTP_RES: -3}
RES=${HTTP_RES:0:${#HTTP_RES}-3}


if [[ $HTTP_STATUS -eq 200 ]]; then

  #Distributing the response into id and text
  id=$(echo "$RES" | jq -r '.id')
  text=$(echo "$RES" | jq -r '.text')

  # Checking if ID exists in the file.
  if check_id "$id"; then
    echo "$text"
  else
    data="{ \"id\":$id, \"text\":\"$text\" }"
    add_excuse "$data"
    echo "$text"
  fi
else
  # When error occurs we will fetch the excuse from the file.
  get_random_excuse
fi
