var express = require('express');
var fs = require('fs');
var morgan = require('morgan');

var prepareCode = require('./lib/prepare-code');

var app = express();

app.set('view engine', 'jade');

var codeBlocks = {};
fs.readdirSync(__dirname + '/views/languages').forEach(function(filename) {
  if (filename.substr(-5) != '.code') return;
  var key = filename.substr(0, filename.length - 5);
  codeBlocks[key] = fs.readFileSync(__dirname + '/views/languages/' + key + '.code', 'utf-8');
});

app.use(morgan('dev'));

app.use(function(req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  next();
});

app.get('/metadata', function(req, res) {
  res.json({});
});

app.get('/show', function(req, res) {
  function renderCode(key) {
    return prepareCode(codeBlocks[key], {
      server: req.query.server,
      documentSetId: req.query.documentSetId,
      vizId: req.query.vizId,
      apiToken: req.query.apiToken
    });
  }
  res.render('show', { renderCode: renderCode });
});

app.listen(9001);
