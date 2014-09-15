Backbone = require('backbone')
$ = require('jquery')
Backbone.$ = $

App = require('./app')
Entities = require('./collections/Entities')

queryString = (->
  map = {}

  list = window.location.search
    .split(/[\?&]/g)
    .map((x) -> x.split('=', 2))

  for x in list
    map[x[0]] = x[1]

  map
)()

Backbone.ajax = (options) ->
  options = $.extend({
    beforeSend: (xhr) ->
      xhr.setRequestHeader('Authorization', "Basic #{new Buffer("#{queryString.apiToken}:x-auth-token").toString('base64')}")
  }, options)
  $.ajax(options)

$ ->
  entities = new Entities([], vizId: queryString.vizId)
  entities.fetch()

  app = new App
    el: $('#app')[0]
    entities: entities
    documentSetId: queryString.documentSetId
  app.render()
