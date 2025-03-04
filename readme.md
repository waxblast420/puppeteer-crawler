# Web Scraper with Puppeteer

This project demonstrates how to deploy a web scraper that collects all the links from a given webpage using Puppeteer in a Node.js environment. It's designed to be used with Leapcell (leapcell.io), and the goal is to help users learn how to deploy projects that depend on web scraping.

## Prerequisites

Before running the application, you need to prepare the Puppeteer environment. To do so, execute the following script:

```bash
sh prepare_puppeteer_env.sh
```

This will:

1. Install Puppeteer and its dependencies (without downloading Chromium, as we will use Google Chrome).
2. Install Google Chrome on your environment.
3. Set up the necessary dependencies for running Puppeteer.

## Project Structure

```plaintext
.
├── LICENSE                           # License file for the project
├── package.json                      # Contains metadata and dependencies for the Node.js project
├── prepare_puppeteer_env.sh           # Script for setting up the Puppeteer environment
└── src
    ├── app.js                        # Main application entry point using Express and Puppeteer
    └── views
        ├── error.ejs                 # Error page template displayed when something goes wrong
        ├── partials
        │   └── header.ejs            # Header template shared across pages
        └── success.ejs               # Success page template, showing the scraped links
```

## Running the Application

Once you've prepared the environment, you can start the web service with the following command:

```bash
npm start
```

The service will be available on `http://localhost:3000`, and you can input the URL of the page you want to scrape. It will return a list of all links on that page.

---

### Explanation of `prepare_puppeteer_env.sh`

This script is responsible for setting up the environment necessary for Puppeteer to run. Here's a breakdown of what each line does:

```bash
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
```

- `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm install puppeteer`: This installs Puppeteer without downloading Chromium, as Google Chrome will be used instead.
- The subsequent commands update the system package list, install the necessary tools (like `wget` and `gnupg`), and add Google's signing key and repository for installing Google Chrome.

- `apt-get install -y google-chrome-stable`: This installs Google Chrome along with necessary fonts and libraries to ensure Puppeteer runs properly with the browser.

- The script then finds and moves the installed `google-chrome-stable` executable to the current directory for Puppeteer to use.

---

## Contact Support

If you have any issues or questions, feel free to reach out to support@leapcell.io.
