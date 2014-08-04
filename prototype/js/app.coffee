Backbone = require('backbone')
EntityListView = require('./views/EntityListView')
EntityFormView = require('./views/EntityFormView')

module.exports = class App extends Backbone.View
  template: require('./templates/app')

  initialize: (options) ->
    throw 'Must pass options.entities, an Entities Collection' if !options.entities
    @entities = options.entities
    @children = []

  clearChildren: ->
    @children.forEach((c) => c.remove())
    @children = []

  render: ->
    @clearChildren()
    @$el.html(@template())
    @ui =
      entityList: @$('.entity-list')
      entityForm: @$('.entity-form')
      documentList: @$('.document-list')
    @children = [
      new EntityListView(collection: @entities, el: @ui.entityList)
      formView = new EntityFormView(el: @ui.entityForm)
    ]
    child.render() for child in @children
    @listenTo(formView, 'create', @onCreate)
    @

  onCreate: (attributes) ->
    @entities.create(attributes)
