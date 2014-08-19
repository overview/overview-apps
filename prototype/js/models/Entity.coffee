_ = require('lodash')
Backbone = require('backbone')

# An entity. Has a name and some terms.
#
# Giant hack time: an Entity is immutable. Its id attribute, "query", is a
# wonky string that lets us store it as a Search in the database.
#
# To "edit" an Entity, destroy it and create a new one.
module.exports = class Entity extends Backbone.Model
  defaults:
    name: ''
    terms: []
    nDocuments: 0

  parse: (json) -> _.extend({ id: json.id }, json.json)
  toJSON: -> { json: @attributes }
