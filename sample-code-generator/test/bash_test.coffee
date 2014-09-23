assert = require('assert')
fs = require('fs')
prepareCode = require('../lib/prepare-code')
spawn = require('child_process').spawn

Vars =
  server: 'SERVER'
  documentSetId: 'DOCUMENT_SET_ID'
  vizId: 'VIZ_ID'
  apiToken: 'API_TOKEN'

describe 'bash.code', ->
  beforeEach ->
    @vars = {}
    for k, v of Vars
      if v not of process.env
        throw "You must set the #{v} environment variable"
      @vars[k] = process.env[v]

  it 'should work', (done) ->
    inFile = "#{__dirname}/../views/languages/bash.code"
    
    fs.readFile inFile, { encoding: 'utf-8' }, (err, bashCode) =>
      return done(err) if err?

      bashCode = prepareCode(bashCode, @vars)

      bash = spawn('bash', [], { stdio: [ 'pipe', 1, 2 ] })
      bash.on 'close', (code) ->
        err = code && "Script exited with error code #{code}" || null
        assert.ifError(err)
        done(err)

      bash.stdin.end(bashCode)
