#!/bin/bash
 
# Confirmation screen
echo "This script will download and set up AutoDarts."
echo "Please ensure you have reset the OS before running this script."
echo
read -p "Do you wish to continue? (y/n): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Setup aborted."
    exit 1
fi

# Temporary directory
TMP_DIR="/tmp/autodarts-setup_$(date +%s)"
sudo mkdir -p "$TMP_DIR"

# Download the ZIP file
ZIP_URL="https://github.com/hwalker928/autodarts-setup/archive/refs/heads/master.zip"
ZIP_FILE="$TMP_DIR/repo.zip"

echo "Downloading files"
sudo curl -L "$ZIP_URL" -o "$ZIP_FILE"

# Extract the ZIP file
# Check if unzip is installed, if not, install it
if ! command -v unzip &> /dev/null
then
    echo "unzip could not be found, installing it..."
    sudo apt-get update
    sudo apt-get install -y unzip
fi

sudo unzip "$ZIP_FILE" -d "$TMP_DIR"
EXTRACTED_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d | tail -n 1)

# Change to the extracted directory
cd "$EXTRACTED_DIR" || exit 1

# Make autodarts.sh executable and run it
chmod +x autodarts.sh
./autodarts.sh

cd ~ || exit 1