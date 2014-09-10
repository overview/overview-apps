express = require('express')
morgan = require('morgan')
serveStatic = require('serve-static')

app = express()

app.use(morgan('dev'))

app.use (req, res, next) ->
  res.set('Access-Control-Allow-Origin', '*')
  next()

app.get '/metadata', (req, res) ->
  res.send('ok')

app.use(serveStatic('dist'))

app.listen(9001)
