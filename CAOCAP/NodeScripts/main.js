console.log('Hello from embedded Node.js!');

const http = require('http');
http.createServer((req, res) => {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello from Node.js server on iOS\n');
}).listen(3000);

/*
 var http = require('http');
 var versions_server = http.createServer((request, response) => {
     response.end('Versions: ' + JSON.stringify(process.versions));
 });
 versions_server.listen(3000);
 */
