_ = require('lodash')
Backbone = require('backbone')

module.exports = class Entities extends Backbone.Collection
  comparator: 'name'
  model: require('../models/Entity')
  url: ->
    ret = "#{@server}/api/v1/vizs/#{@vizId}/objects"
    console.log(ret)
    ret

  initialize: (models, options) ->
    throw 'Must pass options.vizId' if !options.vizId
    throw 'Must pass options.server, a URL' if !options.server

    @vizId = options.vizId
    @server = options.server
