Backbone = require('backbone')

module.exports = class EntityFormView extends Backbone.View
  className: 'new-entity'

  template: require('../templates/EntityForm')

  events:
    'submit form': 'onSubmit'

  initialize: (options) ->
    throw 'Must pass options.documentSetId, a Number' if !options?.documentSetId

    @documentSetId = options.documentSetId

  render: ->
    @$el.html(@template())

  onSubmit: (e) ->
    e.preventDefault()

    name = @$('input[name=name]').val().trim()
    terms = @$('input[name=terms]').val()
      .split(/[\s,]+/g)
      .filter((x) -> !!x)

    if name && terms.length
      Backbone.ajax
        url: "http://localhost:9000/api/v1/document-sets/#{@documentSetId}/documents?fields=id&q=" + encodeURIComponent(terms.join(" "))
        success: (ids) =>
          @trigger('create', name: name, terms: terms, nDocuments: ids.length)
          @$('form')[0].reset()
