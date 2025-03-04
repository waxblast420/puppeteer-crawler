#!/bin/sh

# Install puppeteer and its dependencies
# Skip Chromium download as we'll use Google Chrome later
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm install puppeteer

# Install Google Chrome 
# Update the package list
apt-get update \
    # Install wget and gnupg for key management
    && apt-get install -y wget gnupg \
    # Add Google's signing key
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    # Add Google Chrome repository to apt sources
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    # Update the package list again after adding the new repository
    && apt-get update \
    # Install Google Chrome Stable and necessary fonts and libraries
    # --no-install-recommends skips installing recommended but non-essential packages
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    # Remove the apt cache to save disk space
    && rm -rf /var/lib/apt/lists/*

# Copy google-chrome-stable to the current directory
# Find the path of google-chrome-stable
chrome_path=$(which google-chrome-stable)

# Check if google-chrome-stable is found
if [ -n "$chrome_path" ]; then
    # Move the Chrome executable to the current directory
    mv "$chrome_path" .
    echo "google-chrome-stable moved to current directory."
else
    # Print an error message if Chrome is not found
    echo "not found google-chrome-stable"
    # Exit the script with an error code
    exit 1
fi