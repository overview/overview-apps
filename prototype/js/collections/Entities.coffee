_ = require('lodash')
Backbone = require('backbone')

module.exports = class Entities extends Backbone.Collection
  model: require('../models/Entity')
  url: -> "http://localhost:9000/api/v1/vizs/#{@vizId}/objects"

  initialize: (models, options) ->
    throw 'Must pass options.vizId' if !options.vizId

    @vizId = options.vizId
