module.exports = (config) ->
  config.set
    browsers: [ 'PhantomJS' ]
    frameworks: [ 'browserify', 'mocha' ]
    reporters: [ 'mocha' ]

    files: [
      'test/*Test.coffee'
    ]

    preprocessors:
      'test/*Test.coffee': [ 'browserify' ]

    browserify:
      extensions: [ '.js', '.coffee', '.jade' ]
      transform: [ 'coffeeify', 'jadeify' ]
      debug: true
