gulp = require('gulp')
gutil = require('gulp-util')
jade = require('gulp-jade')
less = require('gulp-less')
rimraf = require('gulp-rimraf')
source = require('vinyl-source-stream')
webserver = require('gulp-webserver')

browserify = require('browserify')
watchify = require('watchify')
browserifyJade = require('browserify-jade')

startBrowserify = (watch) ->
  options =
    cache: {}
    packageCache: {}
    fullPaths: true
    entries: [ './js/main.coffee' ]
    extensions: [ '.coffee', '.js', '.json', '.jade' ]
    debug: true # enable source maps

  bundler = watchify(browserify(options))
  bundler.transform('coffeeify')
  bundler.transform(browserifyJade.jade({
    pretty: false
  }))

  rebundle = ->
    bundler.bundle()
      .on('error', (e) -> gutil.log('Browserify error:', e.message))
      .pipe(source('main.js'))
      .pipe(gulp.dest('dist/js'))

  if watch
    bundler.on('update', rebundle)

  rebundle()

# All files go in dist/
gulp.task 'clean', ->
  gulp.src('./dist', read: false)
    .pipe(rimraf(force: true))

# ./css/**/*.less -> ./dist/css/main.less
doCss = ->
  gulp.src('./css/main.less')
    .pipe(less())
    .pipe(gulp.dest('dist/css'))
gulp.task('css', [ 'clean' ], doCss)
gulp.task('css-noclean', doCss)
gulp.task 'watch-css', [ 'css' ], ->
  gulp.watch('./css/**/*', [ 'css-noclean' ])

# ./js/**/*.(coffee|js) -> ./dist/app.js
gulp.task('js', [ 'clean' ], -> startBrowserify(false))
gulp.task('watch-js', [ 'clean' ], -> startBrowserify(true))

# ./app/**/* -> ./dist/**/*
doApp = ->
  gulp.src('./app/**/*')
    .pipe(gulp.dest('dist'))
gulp.task('app', [ 'clean' ], doApp)
gulp.task('app-noclean', doApp)
gulp.task 'watch-app', [ 'app' ], ->
  gulp.watch('./app/**/*', [ 'app-noclean' ])

# ./jade/**/*.jade -> ./dist/**/*.html
doJade = ->
  gulp.src('./jade/**/*.jade')
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('dist'))
gulp.task('jade', [ 'clean' ], doJade)
gulp.task('jade-noclean', doJade)
gulp.task 'watch-jade', [ 'jade' ], ->
  gulp.watch('./jade/**/*.jade', [ 'jade-noclean' ])

gulp.task 'watch', [ 'watch-css', 'watch-js', 'watch-jade', 'watch-app' ], ->

gulp.task 'server', ->
  gulp.src('dist')
    .pipe(webserver({
      port: 9001
      fallback: 'index.html'
    }))

gulp.task 'default', [ 'watch', 'server' ]
