Marionette = require('backbone.marionette')

module.exports = class VizView extends Marionette.ItemView
  tagName: 'div'
  className: 'viz'

  events:
    'submit form': 'onSubmit'

  modelEvents:
    change: 'render'

  ui:
    title: '[name=title]'
    json_foo: '[name="json.foo"]'
    json_bar: '[name="json.bar"]'

  template: require('../templates/Viz')

  onSubmit: (e) ->
    e.preventDefault()

    title = @ui.title.val()
    json =
      foo: @ui.json_foo.val()
      bar: @ui.json_bar.val()

    @model.save(title: title, json: json)
