// Log a message indicating that the embedded Node.js environment has started successfully
console.log('Hello from embedded Node.js!');

// Import the 'http' module, which provides functionality to create an HTTP server
const http = require('http');

// Define the initial port to start the server on
let port = 3000;

/**
 * Function to start the HTTP server on a specified port
 * @param {number} port - The port number on which the server should listen
 */
const startServer = (port) => {
    // Create an HTTP server that responds to all requests with a simple text message
    const server = http.createServer((req, res) => {
        // Set the HTTP response header with a status code of 200 (OK) and a content type of 'text/plain'
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        // Send the response body containing a message
        res.end('Hello from Node.js server on iOS\n');
    });

    // Start the server and make it listen on the specified port
    server.listen(port, () => {
        // Log a message indicating the port on which the server is running
        console.log(`Server running on port ${port}`);
    });

    // Add an event listener for the 'error' event, which is emitted when the server encounters an error
    server.on('error', (e) => {
        // Check if the error is due to the port being already in use
        if (e.code === 'EADDRINUSE') {
            // Log a message indicating the port is in use and that the server will try the next port
            console.log(`Port ${port} is in use, trying port ${++port}...`);
            // Recursively call startServer with the next port number
            startServer(port);
        } else {
            // If a different error occurs, log the error message
            console.error(`Server error: ${e}`);
        }
    });
};

// Start the server on the initial port (3000)
startServer(port);
