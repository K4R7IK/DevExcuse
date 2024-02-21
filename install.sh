#!/bin/bash

check() {
	command -v "$1" &>/dev/null
}

# Set destination directory
DEST=$HOME/.local/bin

# Check if $DEST exists and create if not
if [ ! -d "$DEST" ]; then
	echo "Creating $DEST directory..."
	mkdir -p "$DEST"
fi

# Create .config directory if not exist
CONFIG_DIR="$HOME/.config"
if [ ! -d "$CONFIG_DIR" ]; then
	echo "Creating $CONFIG_DIR directory..."
	mkdir -p "$CONFIG_DIR"
fi

checks() {

	# check if DEST in PATH variable
	if [[ ":$PATH:" != *":$DEST:"* ]]; then
		echo "$DEST is not in PATH variable. Add it to PATH variable."
	fi

	# Call function to check dependencies
	check_dependencies
}

# Getting the package manager
get_package_manager() {
	if check apt; then
		PACKAGE_MANAGER="apt"
	elif check yum; then
		PACKAGE_MANAGER="yum"
	elif check dnf; then
		PACKAGE_MANAGER="dnf"
	elif check pacman; then
		PACKAGE_MANAGER="pacman"
	elif check yay; then
		PACKAGE_MANAGER="yay"
	elif check zypper; then
		PACKAGE_MANAGER="zypper"
	else
		PACKAGE_MANAGER="Unknown"
	fi
}

# Install dependencies
install_dependencies() {
	case $PACKAGE_MANAGER in
	"apt")
		sudo apt update
		sudo apt install -y "${MISSING_DEPENDENCIES[@]}"
		;;
	"yum" | "dnf")
		sudo yum install -y "${MISSING_DEPENDENCIES[@]}"
		;;
	"pacman" | "yay")
		sudo $PACKAGE_MANAGER -Sy --noconfirm "${MISSING_DEPENDENCIES[@]}"
		;;
	"zypper")
		sudo zypper install -y "${MISSING_DEPENDENCIES[@]}"
		;;
	*)
		echo "Unknown package manager. Please install curl and jq manually."
		;;
	esac
}

# Check dependencies
check_dependencies() {
	get_package_manager
	MISSING_DEPENDENCIES=()

	# Check for curl
	if ! check curl; then
		MISSING_DEPENDENCIES+=("curl")
	fi

	# Check for jq
	if ! check jq; then
		MISSING_DEPENDENCIES+=("jq")
	fi

	if [ ${#MISSING_DEPENDENCIES[@]} -gt 0 ]; then
		echo "Missing dependencies: ${MISSING_DEPENDENCIES[*]}"
		echo "Installing dependencies..."
		install_dependencies
	else
		echo "All dependencies are installed."
	fi
}

install() {
	checks
	# Download excuse database
	echo "Installing Excuse database..."
	curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/excuse.json -o "$CONFIG_DIR/excuse.json"

	# Download devexcuse script
	echo "Installing devexcuse..."
	curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/devexcuse.sh -o "$DEST/devexcuse"

	# Set executable permissions
	echo "Setting executable permissions..."
	chmod +x "$DEST/devexcuse"
}

uninstall() {
	echo "Uninstalling devexcuse..."
	rm -f "$DEST/devexcuse"

	# user if the want to remove the database
	read -r -p "Do you want to remove the excuse database? [y/N]: " response
	case $response in
	[yY][eE][sS] | [yY])
		echo "Uninstalling Excuse database..."
		rm -f "$CONFIG_DIR/excuse.json"
		;;
	esac
	echo "Uninstall complete."
}

case $1 in
"uninstall")
	uninstall
	exit
	;;
esac

install
