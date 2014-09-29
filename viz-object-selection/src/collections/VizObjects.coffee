Backbone = require('backbone')

module.exports = class VizObjects extends Backbone.Collection
  model: require('../models/VizObject')
  url: -> "/vizs/#{global.vizId}/objects"
