Backbone = require('backbone')

# A viz. Stores viz-wide data.
module.exports = class Viz extends Backbone.Model
  url: -> "http://localhost:9000/api/v1/vizs/#{@id}"

  defaults:
    title: ''
    json: {}
