_ = require('lodash')
Marionette = require('backbone.marionette')

class VizObjectsItemView extends Marionette.ItemView
  tagName: 'li'
  className: 'viz-object'
  attributes: -> { 'data-viz-object-id': @model.id }
  events:
    'click a': '_onClick'

  template: _.template('''
    <a href="#" data-viz-object-id="<%- id %>"><%- json.name %></a>
  ''')

  _onClick: (e) ->
    e.preventDefault()
    objectId = e.target.getAttribute('data-viz-object-id')
    window.parent.postMessage({
      call: 'setDocumentListParams'
      args: [ { objects: [ objectId ], name: @model.attributes.json.name } ]
    }, global.server)

class VizObjectsEmptyView extends Marionette.ItemView
  tagName: 'li'
  className: 'empty'
  template: _.template('''<p>You have not created any objects.</p>''')

module.exports = class VizObjectsView extends Marionette.CollectionView
  tagName: 'ul'
  className: 'viz-objects'
  childView: VizObjectsItemView
  emptyView: VizObjectsEmptyView
