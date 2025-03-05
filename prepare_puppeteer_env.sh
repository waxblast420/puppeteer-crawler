#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install Puppeteer without downloading Chromium (we'll use Google Chrome instead)
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm install puppeteer

# Update package list and install required dependencies
apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*  # Clean up apt cache to save space

# Find the path of google-chrome-stable
chrome_path=$(which google-chrome-stable || true)

# Verify if Google Chrome was installed successfully
if [ -n "$chrome_path" ]; then
    # Move the Chrome executable to the current directory
    mv "$chrome_path" .
    echo "google-chrome-stable moved to current directory."
else
    echo "Error: google-chrome-stable not found."
    exit 1
fi