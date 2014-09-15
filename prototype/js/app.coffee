Backbone = require('backbone')
EntityListView = require('./views/EntityListView')
EntityFormView = require('./views/EntityFormView')
VizView = require('./views/VizView')

module.exports = class App extends Backbone.View
  template: require('./templates/app')

  initialize: (options) ->
    throw 'Must pass options.entities, an Entities Collection' if !options.entities
    throw 'Must pass options.documentSetId, a Number' if !options.documentSetId
    @documentSetId = options.documentSetId
    @entities = options.entities
    @children = {}

  clearChildren: ->
    c.remove() for __, c of @children
    @children = {}

  render: ->
    @clearChildren()
    @$el.html(@template())
    @ui =
      entityList: @$('.entity-list')
      entityForm: @$('.entity-form')
      documentList: @$('.document-list')

    @children =
      entityList: new EntityListView(collection: @entities)
      entityForm: new EntityFormView(documentSetId: @documentSetId)

    for k, view of @children
      view.render()
      @ui[k].append(view.el)

    @listenTo(@children.entityForm, 'create', @onCreate)
    @

  onCreate: (attributes) ->
    @entities.create(attributes)
