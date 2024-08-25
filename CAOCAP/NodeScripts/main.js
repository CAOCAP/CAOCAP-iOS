console.log('Hello from embedded Node.js!');

const http = require('http');

let port = 3000;

// Function to start the server
const startServer = (port) => {
    const server = http.createServer((req, res) => {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('Hello from Node.js server on iOS\n');
    });

    server.listen(port, () => {
        console.log(`Server running on port ${port}`);
    });

    server.on('error', (e) => {
        if (e.code === 'EADDRINUSE') {
            console.log(`Port ${port} is in use, trying port ${++port}...`);
            startServer(port);
        } else {
            console.error(`Server error: ${e}`);
        }
    });
};

// Start the server on the initial port
startServer(port);
