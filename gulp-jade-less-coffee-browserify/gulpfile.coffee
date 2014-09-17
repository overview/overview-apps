browserify = require('browserify')
express = require('express')
gulp = require('gulp')
jade = require('gulp-jade')
morgan = require('morgan')
less = require('gulp-less')
serveStatic = require('serve-static')
source = require('vinyl-source-stream')
watchify = require('watchify')

buildBrowserify = ->
  browserify({
    cache: {}
    packageCache: {}
    fullPaths: true
    entries: [
      './src/main.coffee'
    ]
    extensions: [ '.js', '.coffee', '.jade' ]
    debug: true
  })
    .transform('coffeeify')
    .transform('jadeify')

gulp.task 'browserify', ->
  buildBrowserify()
    .plugin('minifyify', map: 'main.js', output: './dist/main.js.map')
    .bundle()
    .on('error', console.warn)
    .pipe(source('main.js'))
    .pipe(gulp.dest('./dist/'))

gulp.task 'browserify-dev', ->
  bundler = watchify(buildBrowserify(), watchify.args)

  rebundle = ->
    bundler.bundle()
      .on('error', console.warn)
      .pipe(source('main.js'))
      .pipe(gulp.dest('./dist/'))

  bundler.on('update', rebundle)
  rebundle()

gulp.task 'jade', ->
  gulp.src('./jade/**/*.jade')
    .pipe(jade())
    .pipe(gulp.dest('dist'))

gulp.task 'less', ->
  gulp.src('./less/show.less')
    .pipe(less())
    .pipe(gulp.dest('dist'))

gulp.task 'dev', [ 'browserify-dev', 'jade', 'less' ], ->
  gulp.watch('./less/**/*.less', [ 'less' ])
  gulp.watch('./jade/**/*.jade', [ 'jade' ])

gulp.task 'dist', [ 'browserify', 'jade', 'less' ]

gulp.task 'default', [ 'dev' ], ->
  # Start a web server
  app = express()
  app.use(morgan('dev'))
  app.use(serveStatic('dist', {
    extensions: [ 'html' ]
    setHeaders: (res) -> res.setHeader('Access-Control-Allow-Origin', '*')
  }))
  app.listen(8000)
  console.log('Serving at http://localhost:8000')
