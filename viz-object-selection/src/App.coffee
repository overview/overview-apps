$ = require('jquery')
Backbone = require('backbone')
VizObjects = require('./collections/VizObjects')
VizObjectsView = require('./views/VizObjectsView')
CreatorView = require('./views/CreatorView')

module.exports = class App
  constructor: ->
    @vizObjects = new VizObjects()
    @vizObjects.fetch()

  attach: (el) ->
    @$el = $(el)

    @objectsView = new VizObjectsView(collection: @vizObjects)
    @objectsView.render()

    @$el.append(@objectsView.el)

    Backbone.ajax
      url: "/document-sets/#{global.documentSetId}/documents?fields=id"
      success: (ids) =>
        @creatorView = new CreatorView(collection: @vizObjects, documentIds: ids)
        @creatorView.render()
        @$el.append(@creatorView.el)

    undefined
