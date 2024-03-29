#!/usr/bin/env bash

check_dependencies() {
	# Checks if all dependencies are installed
	for dep in "${dependencies[@]}"; do
		if ! command -v "$dep" &>/dev/null; then
			echo "$dep is not installed."
			exit 1
		fi
	done
}

dependencies=("jq" "curl")

# check if all dependencies are installed
# if not installed, exit the script
check_dependencies

#Defining location
DATAFILE="$HOME/.config/excuse.json"

if [[ ! -f "$DATAFILE" ]]; then
	echo "Installing Excuse database..."
	curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/excuse.json -o "$DATAFILE"
fi

get_random_excuse() {
	jq -r '.[] | select(.text_en) | .text_en' "$DATAFILE" | shuf -n 1
}

get_random_excuse
