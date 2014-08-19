Marionette = require('backbone.marionette')

module.exports = class EntityItemView extends Marionette.ItemView
  tagName: 'li'
  className: 'entity'

  events:
    'click .delete': 'onDelete'

  template: require('../templates/EntityItem')

  serializeData: -> @model.attributes

  onDelete: (e) ->
    e.preventDefault()

    console.log(e, @model)

    if window.confirm('Are you sure you want to delete this entity?')
      @model.destroy()
