gulp       = require 'gulp'

coffee     = require 'gulp-coffee'
mocha      = require 'gulp-mocha'
nodemon    = require 'gulp-nodemon'
# browserify = require 'gulp-browserify'
rename     = require "gulp-rename"
# stylus     = require 'gulp-stylus'
del        = require 'del'
path       = require 'path'
# watchify   = require 'watchify'
# source     = require 'vinyl-source-stream'
# coffeeify  = require 'coffeeify'

sources      =
  code         : [
    'src/**/*.coffee'
  ]
  test       : 'test/**/*.coffee'

destinations =
  code       : 'build/'

gulp.task 'clean', (done) ->
  dirs = (directory + '/*' for name, directory of destinations)
  del dirs, done


gulp.task 'build', ['clean'], ->
  gulp
    .src sources.code
    .pipe coffee()
    .pipe gulp.dest destinations.code


gulp.task 'watch', ->
  gulp.watch sources.code, ['build']
  gulp.watch [
    sources.test
    destinations.code
  ], ['test']

gulp.task 'test', ->
  gulp.src sources.test
    .pipe mocha
      compilers : 'coffee:coffee-script'
      reporter  : 'spec'

gulp.task 'develop', ['build', 'test', 'watch']

gulp.task 'default', ['develop']
