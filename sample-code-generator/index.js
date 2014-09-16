var express = require('express');
var morgan = require('morgan');

var app = express();

app.set('view engine', 'jade');
app.use(morgan('dev'));

app.use(function(req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  next();
});

app.get('/metadata', function(req, res) {
  res.json({});
});

app.get('/show', function(req, res) {
  res.render('show', {
    server: req.query.server,
    documentSetId: req.query.documentSetId,
    vizId: req.query.vizId,
    apiToken: req.query.apiToken
  });
});

app.listen(9001);
