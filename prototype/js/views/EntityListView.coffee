Marionette = require('backbone.marionette')

module.exports = class EntityListView extends Marionette.CollectionView
  tagName: 'ul'
  className: 'entities'

  childView: require('./EntityItemView')
