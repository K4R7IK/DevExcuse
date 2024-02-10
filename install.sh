# Script that install devexcuse script in /usr/local/bin

# Getting the package manager
get_package_manager() {
  if command -v apt-get &>/dev/null; then
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
      sudo apt-get update
      sudo apt-get install -y ${MISSING_DEPENDENCIES[@]}
      ;;
    "yum" | "dnf")
      sudo yum install -y ${MISSING_DEPENDENCIES[@]}
      ;;
    "pacman")
      sudo pacman -Sy --noconfirm ${MISSING_DEPENDENCIES[@]}
      ;;
    "zypper")
      sudo zypper install -y ${MISSING_DEPENDENCIES[@]}
      ;;
    *)
      echo "Unknown package manager. Please install curl and jq manually."
      ;;
  esac
}

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

check_dependencies
echo "Installing Excuse database..."
curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/excuse.json -o $HOME/.config/excuse.json

echo "Installing devexcuse..."
curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/devexcuse.sh -o $HOME/.local/bin/devexcuse

echo "Setting executable permissions..."
chmod +x $HOME/.local/bin/devexcuse
