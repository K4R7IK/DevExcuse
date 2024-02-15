#!/bin/bash

# Set destination directory
DEST=$HOME/.local/bin

# Check if $DEST exists and create if not
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST"
fi

# Getting the package manager
get_package_manager() {
  if command -v apt &>/dev/null; then
    PACKAGE_MANAGER="apt"
  elif command -v yum &>/dev/null; then
    PACKAGE_MANAGER="yum"
  elif command -v dnf &>/dev/null; then
    PACKAGE_MANAGER="dnf"
  elif command -v pacman &>/dev/null; then
    PACKAGE_MANAGER="pacman"
  elif command -v zypper &>/dev/null; then
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
    "pacman")
      sudo pacman -Sy --noconfirm "${MISSING_DEPENDENCIES[@]}"
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
  if ! command -v curl &>/dev/null; then
    MISSING_DEPENDENCIES+=("curl")
  fi

  # Check for jq
  if ! command -v jq &>/dev/null; then
    MISSING_DEPENDENCIES+=("jq")
  fi

  if [ ${#MISSING_DEPENDENCIES[@]} -gt 0 ]; then
    echo "Missing dependencies: ${MISSING_DEPENDENCIES[@]}"
    echo "Installing dependencies..."
    install_dependencies
  else
    echo "All dependencies are installed."
  fi
}

# Call function to check dependencies
check_dependencies

# Create .config directory if not exist
CONFIG_DIR="$HOME/.config"
if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
fi

# Download excuse database
echo "Installing Excuse database..."
curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/excuse.json -o "$CONFIG_DIR/excuse.json"

# Download devexcuse script
echo "Installing devexcuse..."
curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/devexcuse.sh -o "$DEST/devexcuse"

# Set executable permissions
echo "Setting executable permissions..."
chmod +x "$DEST/devexcuse"
