Backbone = require('backbone')

module.exports = class EntityFormView extends Backbone.View
  className: 'new-entity'

  template: require('../templates/EntityForm')

  events:
    'submit form': 'onSubmit'

  render: ->
    @$el.html(@template())

  onSubmit: (e) ->
    e.preventDefault()

    name = @$('input[name=name]').val().trim()
    terms = @$('input[name=terms]').val()
      .split(/[\s,]+/g)
      .filter((x) -> !!x)

    if name && terms.length
      @trigger('create', name: name, terms: terms)
      @$('form')[0].reset()
