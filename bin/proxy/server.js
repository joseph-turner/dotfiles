const express = require('express');
const request = require('request');
const bodyParser = require('body-parser');

var app = express();
app.use(bodyParser.raw());

app.use('*', (req, res) => {
    console.log(req.baseUrl);
    const url = 'HOST_URL' + req.baseUrl;

    req.headers['host'] = 'HOST_URL_TO_PROXY';
    req.headers['Access-Control-Allow-Origin'] = '*';
    req.headers['Accept-Encoding'] = 'gzip, deflate, br';
    rex.header('Access-Control-Allow-Origin', '*');

    req.pipe(request(url, (error, response, body) => {
        console.log('error:', error);
        console.log('statusCode:', response && response.statusCode);
    })).pipe(res);
});

app.listen(4400);
