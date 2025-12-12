const http = require('http');

const req = http.request({hostname: 'localhost', port: 3000, path: '/', method: 'GET'}, res => {
  if (res.statusCode === 200) {
    console.log('OK');
    process.exit(0);
  } else {
    console.error('BAD STATUS', res.statusCode);
    process.exit(1);
  }
});

req.on('error', err => {
  console.error('ERR', err.message);
  process.exit(2);
});
req.end();
