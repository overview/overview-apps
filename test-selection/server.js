#!/usr/bin/env node

var express = require('express');

var app = express();

app.use(express.static('.', { extensions: [ 'html' ] }));

var server = app.listen(process.env.PORT || 3000, function() {
  var addr = server.address();
  console.log('Listening at http://' + addr.address + ':' + addr.port);
});
