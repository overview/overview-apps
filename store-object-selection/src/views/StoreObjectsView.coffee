_ = require('lodash')
Marionette = require('backbone.marionette')

class StoreObjectsItemView extends Marionette.ItemView
  tagName: 'li'
  className: 'store-object'
  attributes: -> { 'data-store-object-id': @model.id }
  events:
    'click a': '_onClick'

  template: _.template('''
    <a href="#" data-store-object-id="<%- id %>"><%- json.name %></a>
  ''')

  _onClick: (e) ->
    e.preventDefault()
    objectId = e.target.getAttribute('data-store-object-id')
    window.parent.postMessage({
      call: 'setDocumentListParams'
      args: [ { objects: [ objectId ], name: @model.attributes.json.name } ]
    }, global.server)

class StoreObjectsEmptyView extends Marionette.ItemView
  tagName: 'li'
  className: 'empty'
  template: _.template('''<p>You have not created any objects.</p>''')

module.exports = class StoreObjectsView extends Marionette.CollectionView
  tagName: 'ul'
  className: 'store-objects'
  childView: StoreObjectsItemView
  emptyView: StoreObjectsEmptyView
