_ = require('lodash')
Backbone = require('backbone')

# An entity. Has a name and some terms.
#
# Giant hack time: an Entity is immutable. Its id attribute, "query", is a
# wonky string that lets us store it as a Search in the database.
#
# To "edit" an Entity, destroy it and create a new one.
module.exports = class Entity extends Backbone.Model
  idAttribute: 'query'

  defaults:
    name: ''
    terms: []
    state: 'New'
    nDocuments: 0

  # Entity is immutable.
  #
  # If we're saving it, it's new.
  # If we're deleting it, it isn't.
  isNew: -> @attributes.state == 'New'

  initialize: (attributes, options) ->
    if !attributes.query
      query = "\"entity-#{new Buffer(attributes.name || '').toString('base64')}\" OR \"#{(attributes.terms || []).join('" OR "')}\""
      @set(query: query)

    @parsed = options.parse

  parse: (json) ->
    if json && (m = /^"entity-((?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?)" OR "(.*)"$/.exec(json.query))?
      query: json.query
      name: new Buffer(m[1], 'base64').toString('utf-8')
      terms: m[2].split(/"\sOR\s"/g)
      state: json.state
      nDocuments: json.nDocuments
    else
      json
