require('./test_helper')
App = require('../src/App')
$ = require('jquery')

describe 'App', ->
  beforeEach ->
    @sandbox = sinon.sandbox.create()
    @sandbox.stub($, 'ajax').returns new Promise (resolve, reject) =>
      @resolve = resolve
      @reject = reject
    @options =
      server: 'https://example.org'
      documentSetId: '1'
      apiToken: 'asdf'
    @subject = new App(@options)

  afterEach ->
    @sandbox.restore()

  describe '#getDocuments', ->
    beforeEach (done) ->
      @promise = @subject.getDocuments()
      process.nextTick(done)

    it 'should send an HTTP request', ->
      expect($.ajax).to.have.been.called
      options = $.ajax.args[0][0]
      expect(options).to.have.property('url', 'https://example.org/api/v1/document-sets/1/documents')
      expect(options).to.have.property('dataType', 'json')
      expect(options).to.have.deep.property('headers.Authorization', 'Basic YXNkZjp4LWF1dGgtdG9rZW4=')

    it 'should begin unresolved', ->
      expect(@promise.isPending()).to.be.true

    it 'should resolve when the ajax response resolves', ->
      @resolve(items: [{ title: 'a document' }])
      expect(@promise.isPending()).to.be.false
      expect(@promise.value()).to.deep.eq(items: [{ title: 'a document' }])

    it 'should reject when the ajax response rejects', ->
      @reject('an xhr')
      expect(@promise.isPending()).to.be.false
      expect(@promise.reason()).to.eq('an xhr')

  describe '#attach', ->
    beforeEach ->
      @$el = $('<div></div>')
      @sandbox.stub(@subject, 'getDocuments').returns new Promise (resolve, reject) =>
        @resolve = resolve
        @reject = reject
      @subject.attach(@$el[0])

    it 'should show loading', ->
      expect(@$el.text()).to.eq('Loading…')

    it 'should call getDocuments', ->
      expect(@subject.getDocuments).to.have.been.called

    it 'should show error on error', (done) ->
      @reject('an xhr')
      setTimeout(=> # slower than process.nextTick()
        expect(@$el.text()).to.eq('Error')
        done()
      , 0)

    it 'should show documents on success', (done) ->
      @resolve(items: [{ title: 'foo' }])
      setTimeout(=> # slower than process.nextTick()
        expect(@$el.find('ul li').text()).to.eq('foo')
        done()
      , 0)
