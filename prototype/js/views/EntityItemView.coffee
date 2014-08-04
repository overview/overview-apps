Marionette = require('backbone.marionette')

module.exports = class EntityItemView extends Marionette.ItemView
  tagName: 'li'
  className: 'entity'

  events:
    'click .delete': 'onDelete'

  template: require('../templates/EntityItem')

  onDelete: (e) ->
    e.preventDefault()

    if window.confirm('Are you sure you want to delete this entity?')
      @model.destroy()
