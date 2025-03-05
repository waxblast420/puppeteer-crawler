const express = require('express');
const app = express();
// Import Puppeteer for browser automation
const puppeteer = require('puppeteer');
const bodyParser = require('body-parser');
const base64 = require('base64-js');

// Set EJS as the template engine
app.set('view engine', 'ejs');
// Set the directory for views
app.set('views', __dirname + '/views');

// Use body-parser to parse form data
app.use(bodyParser.urlencoded({ extended: true }));

// Handle GET requests and render the initial page
app.get('/', (req, res) => {
    res.render('success', {
        url: 'https://news.ycombinator.com',
        screenshot_base64: '',
        links: [],
        page_title: null
    });
});

// Handle POST requests to take a screenshot
app.post('/', async (req, res) => {
    // Get the URL from the form, default to Hacker News
    let url = req.body.url || 'https://news.ycombinator.com';
    // Add 'https://' if the URL doesn't start with 'http'
    if (!url.startsWith('http')) {
        url = 'https://' + url;
    }

    let browser;
    try {
        // Launch a headless Chrome browser with specific arguments
        browser = await puppeteer.launch({
            headless: true, // Run the browser in headless mode
            args: [
                '--single-process',
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-gpu',
                '--no-zygote',
                '--disable-dev-shm-usage',
            ],
            // Use the stable version of Chrome
            // use specific path to the Chrome executable, because the default path may not work.
            // we have to download the Chrome executable and put it in the project directory.
            executablePath: './google-chrome-stable',
        });
        // Create a new browser page
        const page = await browser.newPage();
        // Navigate to the specified URL and wait until the network is idle
        await page.goto(url, { waitUntil: 'networkidle2' });
        // Take a screenshot of the page
        const screenshot = await page.screenshot();
        // Get the page title
        const page_title = await page.title();

        // Extract all <a> tags' links and text content
        const links_and_texts = await page.evaluate(() => {
            const anchors = document.querySelectorAll('a');
            return Array.from(anchors).map(anchor => {
                const text = anchor.textContent.replace(/<[^>]*>/g, '').trim();
                return {
                    href: anchor.href,
                    text: text
                };
            });
        });

        // Convert the screenshot to a base64 string
        const screenshot_base64 = base64.fromByteArray(screenshot);

        // Render the success page with relevant data
        res.render('success', {
            url,
            page_title,
            screenshot_base64,
            links: links_and_texts
        });
    } catch (e) {
        // Close the browser if an error occurs
        if (browser) {
            await browser.close();
        }
        // Render the error page with the error message
        res.render('error', { error_message: e.message });
    } finally {
        // Ensure the browser is closed after all operations
        if (browser) {
            await browser.close();
        }
    }
});

// Set the port, use environment variable PORT or default to 8080
const port = process.env.PORT || 8080;
// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});