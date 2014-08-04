_ = require('lodash')
Backbone = require('backbone')

module.exports = class Entities extends Backbone.Collection
  model: require('../models/Entity')
  url: -> "http://localhost:9000/api/v1/document-sets/#{@documentSetId}/searches"

  initialize: (models, options) ->
    throw 'Must pass options.documentSetId' if !options.documentSetId

    @documentSetId = options.documentSetId
