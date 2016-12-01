# Requirements
autoprefixer = require 'autoprefixer'
del = require 'del'
gulp = require 'gulp'
gulpAngularTemplatecache = require 'gulp-angular-templatecache'
gulpCoffee = require 'gulp-coffee'
gulpConcat = require 'gulp-concat'
gulpConnect = require 'gulp-connect'
gulpCssnano = require 'gulp-cssnano'
gulpPostcss = require 'gulp-postcss'
gulpSass = require 'gulp-sass'
gulpUglify = require 'gulp-uglify'
gulpUtil = require 'gulp-util'

# Paths
sources =
  styles: 'src/styles/**/*.sass'
  coffee: 'src/app/**/*.coffee'
  templates: 'src/templates/**/*.html'
  index: 'src/index.html'
  img: 'src/img/**/*'
  data: 'src/data/**/*'

destinations =
  styles: 'public/styles'
  scripts: 'public/scripts'
  index: 'public'
  img: 'public/img'
  data: 'public/data'

# Vendors
vendors =
  scripts: [
    'node_modules/jquery/dist/jquery.min.js'
    'node_modules/angular/angular.min.js'
    'node_modules/angular-route/angular-route.min.js'
    'node_modules/lodash/lodash.js'
    'node_modules/moment/min/moment.min.js'
    'node_modules/ilyabirman-likely/release/likely.js'
    'bower_components/tabletop/src/tabletop.js'
    'bower_components/angular-tabletop/TabletopProvider.js'
  ]
  styles: [
    'node_modules/ilyabirman-likely/release/likely.css'
  ]

# Tasks
gulp.task 'clean', ->
  del.sync 'public'
  return

gulp.task 'connect', ->
  gulpConnect.server
    root: 'public'
    fallback: 'public/index.html'
    livereload: true
  return

gulp.task 'index', ->
  gulp.src sources.index
    .pipe gulp.dest destinations.index
    .pipe gulpConnect.reload()
  return

gulp.task 'data', ->
  gulp.src sources.data
    .pipe gulp.dest destinations.data
  return

gulp.task 'img', ->
  gulp.src sources.img
    .pipe gulp.dest destinations.img
  return

gulp.task 'scripts:vendor', ->
  gulp.src vendors.scripts
    .pipe gulpConcat 'vendor.js'
    .pipe gulpUglify()
    .pipe gulp.dest destinations.scripts
  return

gulp.task 'styles:vendor', ->
  gulp.src vendors.styles
    .pipe gulpConcat 'vendor.css'
    .pipe gulpCssnano()
    .pipe gulp.dest destinations.styles
  return

gulp.task 'scripts:app', ->
  gulp.src sources.coffee
    .pipe gulpCoffee bare: true
    .pipe gulpConcat 'app.js'
    .pipe if gulpUtil.env.production then gulpUglify() else gulpUtil.noop()
    .pipe gulp.dest destinations.scripts
    .pipe gulpConnect.reload()
  return

gulp.task 'styles:app', ->
  postCssPlugins = [
    autoprefixer
  ]

  gulp.src sources.styles
    .pipe gulpSass indentedSyntax: true
    .pipe gulpPostcss postCssPlugins
    .pipe gulpConcat 'app.css'
    .pipe if gulpUtil.env.production then gulpCssnano() else gulpUtil.noop()
    .pipe gulp.dest destinations.styles
    .pipe gulpConnect.reload()
  return

gulp.task 'templates', ->
  gulp.src sources.templates
    .pipe gulpAngularTemplatecache module: 'app'
    .pipe if gulpUtil.env.production then gulpUglify() else gulpUtil.noop()
    .pipe gulp.dest destinations.scripts
    .pipe gulpConnect.reload()
  return

gulp.task 'watch', ->
  gulp.watch sources.index, ['index']
  gulp.watch sources.coffee, ['scripts:app']
  gulp.watch sources.styles, ['styles:app']
  gulp.watch sources.templates, ['templates']
  return

gulp.task 'build', [
  'index'
  'data'
  'img'
  'scripts:vendor'
  'styles:vendor'
  'scripts:app'
  'styles:app'
  'templates'
]

gulp.task 'rebuild', ['clean'], ->
  gulp.start 'build'
  return

gulp.task 'dev', [
  'watch'
  'connect'
]
