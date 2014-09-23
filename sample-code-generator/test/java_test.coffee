assert = require('assert')
fs = require('fs')
request = require('request')
rimraf = require('rimraf')
spawn = require('child_process').spawn
temp = require('temp')

prepareCode = require('../lib/prepare-code')

JsonJarUrl = 'http://search.maven.org/remotecontent?filepath=org/glassfish/javax.json/1.0.4/javax.json-1.0.4.jar'
JsonJarName = 'javax.json-1.0.4.jar'

prepare = (inFile, outFile, vars, done) ->
  fs.readFile inFile, { encoding: 'utf-8' }, (err, code) =>
    return done(err) if err?

    code = prepareCode(code, vars)

    fs.writeFile outFile, code, { encoding: 'utf-8' }, (err) =>
      done(err)

downloadJsonJar = (dest, done) ->
  cacheFile = "#{__dirname}/#{JsonJarName}"
  destFile = "#{dest}/#{JsonJarName}"

  writeDest = (blob) -> fs.writeFile(destFile, blob, done)

  fs.readFile cacheFile, (err, blob) ->
    return done(err) if err? && err.code != 'ENOENT'

    if err?.code == 'ENOENT'
      # Download the file to two locations
      request.get { url: JsonJarUrl, encoding: null }, (err, response, blob) ->
        console.log(blob.constructor)
        return done(err) if err?

        fs.writeFile cacheFile, blob, (err) ->
          return done(err) if err?

          writeDest(blob)
    else
      writeDest(blob)

javac = (file, dest, done) ->
  spawn('javac', [ '-cp', "#{dest}/#{JsonJarName}", '-d', dest, file ], stdio: 'inherit')
    .on 'close', (code) ->
      done(code && "javac exited with code #{code}" || null)

java = (dest, done) ->
  spawn('java', [ '-cp', "#{dest}:#{dest}/#{JsonJarName}", 'Main' ], stdio: 'inherit')
    .on 'close', (code) ->
      done(code && "java exited with code #{code}" || null)

Vars =
  server: 'SERVER'
  documentSetId: 'DOCUMENT_SET_ID'
  vizId: 'VIZ_ID'
  apiToken: 'API_TOKEN'

describe 'java.code', ->
  beforeEach (done) ->
    @vars = {}
    for k, v of Vars
      if v not of process.env
        throw "You must set the #{v} environment variable"
      @vars[k] = process.env[v]

    temp.mkdir 'sample-java', (err, path) =>
      @path = path
      done(err)

  afterEach (done) ->
    if @path
      rimraf(@path, done)
    else
      done()

  it 'should work', (done) ->
    inFile = "#{__dirname}/../views/languages/java.code"
    outFile = "#{@path}/Main.java"

    end = (err) =>
      assert.ifError(err)
      done()

    prepare inFile, outFile, @vars, (err) =>
      return end(err) if err?

      downloadJsonJar @path, (err) =>
        return end(err) if err?

        javac outFile, @path, (err) =>
          return end(err) if err?

          java(@path, end)
