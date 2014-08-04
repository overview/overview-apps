Backbone = require('backbone')
$ = require('jquery')
Backbone.$ = $

App = require('./app')
Entities = require('./collections/Entities')

DocumentSetId = '1'
ApiToken = '62xcb9msd0ag8t9ghuycwhlb7'

Backbone.ajax = (options) ->
  options = $.extend({
    beforeSend: (xhr) ->
      xhr.setRequestHeader('Authorization', "Basic #{new Buffer("#{ApiToken}:x-auth-token").toString('base64')}")
  }, options)
  $.ajax(options)

$ ->
  entities = new Entities([], documentSetId: DocumentSetId)

  entities.fetch()

  app = new App
    el: $('#app')[0]
    entities: entities
  app.render()
