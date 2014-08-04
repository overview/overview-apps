Marionette = require('backbone.marionette')

module.exports = class EntityItemView extends Marionette.ItemView
  tagName: 'li'
  className: 'entity'

  template: require('../templates/EntityItem')
