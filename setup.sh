#!/bin/bash

# Temporary directory
TMP_DIR="/tmp/autodarts-setup-files"
mkdir -p "$TMP_DIR"

# Download the ZIP file
ZIP_URL="https://github.com/hwalker928/autodarts-setup/archive/refs/heads/master.zip"
ZIP_FILE="$TMP_DIR/repo.zip"

echo "Downloading files"
curl -L "$ZIP_URL" -o "$ZIP_FILE"

# Extract the ZIP file
unzip "$ZIP_FILE" -d "$TMP_DIR"
EXTRACTED_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d | tail -n 1)

# Change to the extracted directory
cd "$EXTRACTED_DIR" || exit 1

# Make autodarts.sh executable and run it
chmod +x autodarts.sh
./autodarts.sh
