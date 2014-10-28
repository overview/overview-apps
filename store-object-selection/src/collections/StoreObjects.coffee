Backbone = require('backbone')

module.exports = class StoreObjects extends Backbone.Collection
  model: require('../models/StoreObject')
  url: -> '/store/objects'
