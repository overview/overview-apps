Backbone = require('backbone')
$ = require('jquery')
Backbone.$ = $

App = require('./app')
Entities = require('./collections/Entities')
Viz = require('./models/Viz')

DocumentSetId = '451'
VizId = '1937030250496'
ApiToken = '7qhky85pjdbn2vcgvwlxztwgf'

Backbone.ajax = (options) ->
  options = $.extend({
    beforeSend: (xhr) ->
      xhr.setRequestHeader('Authorization', "Basic #{new Buffer("#{ApiToken}:x-auth-token").toString('base64')}")
  }, options)
  $.ajax(options)

$ ->
  viz = new Viz(id: VizId)
  entities = new Entities([], vizId: VizId)

  viz.fetch()
  entities.fetch()

  app = new App
    el: $('#app')[0]
    viz: viz
    entities: entities
  app.render()
