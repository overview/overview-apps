_ = require('lodash')
Backbone = require('backbone')
Marionette = require('backbone.marionette')

module.exports = class CreatorView extends Marionette.ItemView
  className: 'object-creator'

  template: _.template('''
    <form method="post" action="#">
      <p>
        <input type="text" name="name" placeholder="My new object name" />
        <button type="submit">Create a new Object with random Documents</button>
      </p>
    </form>
  ''')

  ui:
    name: '[name=name]'

  initialize: (options) ->
    throw 'Must pass options.collection, a StoreObjects' if !@collection
    throw 'Must pass options.documentIds, an Array of Numbers' if !options?.documentIds
    @documentIds = options.documentIds

  events:
    'submit form': '_onSubmit'

  _onSubmit: (e) ->
    e.preventDefault()
    name = @ui.name.val().trim()

    @collection.create({ json: { name: name } }, {
      success: (vo) =>
        nDocuments = _.random(1, 100)
        ids = _.sample(@documentIds, nDocuments)
        dvos = ids.map((id) -> [ id, vo.id ])

        Backbone.ajax
          type: 'post'
          url: '/store/document-objects'
          data: JSON.stringify(dvos)
          contentType: 'application/json'
          processData: false
      wait: true
    })
