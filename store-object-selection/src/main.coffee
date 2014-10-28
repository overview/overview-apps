$ = require('jquery')
Backbone = require('backbone')
Backbone.$ = $ # ASAP, so other requires use it

# Set global.{apiToken,server,documentSetId}
(->
  QueryString = require('querystring')
  qs = QueryString.parse(window.location.search.substr(1))

  Params =
    server: 'a String'
    documentSetId: 'a String'
    apiToken: 'a String'

  for k, v of Params
    throw "Must pass options.#{k}, a #{v}" if !qs[k]
    global[k] = qs[k]
)()

Backbone.ajax = (options) ->
  auth = new Buffer(global.apiToken + ':x-auth-token').toString('base64')

  url = options.url
  if /^https?:\/\//.test(url) == false
    url = "#{global.server}/api/v1#{url}"

  options = $.extend({}, options, {
    url: url
    dataType: 'json'
    headers:
      Authorization: "Basic #{auth}"
  })
  $.ajax(options)

App = require('./App')

$ ->
  app = new App()
  app.attach($('#app'))
