$ = require('jquery')
Backbone = require('backbone')
StoreObjects = require('./collections/StoreObjects')
StoreObjectsView = require('./views/StoreObjectsView')
CreatorView = require('./views/CreatorView')

module.exports = class App
  constructor: ->
    @storeObjects = new StoreObjects()
    @storeObjects.fetch()

  attach: (el) ->
    @$el = $(el)

    @objectsView = new StoreObjectsView(collection: @storeObjects)
    @objectsView.render()

    @$el.append(@objectsView.el)

    Backbone.ajax
      url: "/document-sets/#{global.documentSetId}/documents?fields=id"
      success: (ids) =>
        @creatorView = new CreatorView(collection: @storeObjects, documentIds: ids)
        @creatorView.render()
        @$el.append(@creatorView.el)

    undefined
