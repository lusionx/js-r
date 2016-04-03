gulp        = require 'gulp'
gutil       = require 'gutil'
_           = require 'lodash'

ngAnnotate  = require 'gulp-ng-annotate'
coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
minifyCSS   = require 'gulp-cssnano'
htmlReplace = require 'gulp-html-replace'
sourcemaps  = require 'gulp-sourcemaps'
less        = require 'gulp-less'
browserify  = require 'gulp-browserify'


getSrc = (re, str, pre='') ->
  lns = str.split '\n'
  _.map lns, (l) ->
    if m = re.exec l
      return pre + m[1]
    null


path =
  coffee:
    src: ['app/scripts/app.coffee', 'app/scripts/*/*.coffee']
  pack: ['impack.js']
  less:
    src: ['app/less/*.less']
  bower: # cp from index.html
    src: getSrc /src="(.+)"/, """
<script src="bower_components/jquery/dist/jquery.min.js"></script>
<script src="bower_components/amazeui/dist/js/amazeui.min.js"></script>
<script src="bower_components/angular/angular.min.js"></script>
<script src="bower_components/angular-sanitize/angular-sanitize.min.js"></script>
<script src="bower_components/angular-resource/angular-resource.min.js"></script>
<script src="bower_components/angular-filter/dist/angular-filter.min.js"></script>
<script src="bower_components/angular-ui-router/release/angular-ui-router.min.js"></script>
""", 'app/'
    css: getSrc /href="(.+)"/, """
<link rel="stylesheet" href="bower_components/amazeui/dist/css/amazeui.min.css">
""", 'app/'


# develop task

gulp.task 'w-coffee', () ->
  ww = gulp.watch path.coffee.src, ['d-app']
  ww.on 'change', (event) ->
    console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'

gulp.task 'd-app', () ->
  gulp.src path.coffee.src
    .pipe coffee().on('error', gutil.log)
    .pipe sourcemaps.init()
    .pipe concat 'app.js'
    .pipe sourcemaps.write './'
    .pipe gulp.dest "app/js/"

gulp.task 'w-less', () ->
  ww = gulp.watch path.less.src, ['d-css']
  ww.on 'change', (event) ->
    console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'

gulp.task 'd-css', () ->
  gulp.src path.less.src
    .pipe less()
    .pipe concat 'app.css'
    .pipe gulp.dest 'app/css/'

# 打包三方package, 防污染window
gulp.task 'd-pack', () ->
  opt =
    insertGlobals: no
    debug: no
  gulp.src path.pack
    .pipe browserify opt
    .pipe gulp.dest 'app/js/'

# build task
gulp.task 'b-pack', () ->
  opt =
    insertGlobals: no
    debug: no
  gulp.src path.pack
    .pipe browserify opt
    .pipe uglify {}
    .pipe gulp.dest 'dist/js/'

gulp.task 'b-app', () ->
  gulp.src path.coffee.src
    .pipe coffee().on('error', gutil.log)
    .pipe ngAnnotate()
    .pipe concat 'app.js'
    .pipe uglify {}
    .pipe gulp.dest 'dist/js/'

gulp.task 'b-vendor', () ->
  gulp.src path.bower.src
    .pipe concat 'vendor.js'
    .pipe gulp.dest 'dist/js/'

gulp.task 'b-css-tmp', ['d-css'], () ->
  gulp.src 'app/css/*.css'
    .pipe minifyCSS()
    .pipe concat 'style.css'
    .pipe gulp.dest 'tmp/css/'

gulp.task 'b-css', ['b-css-tmp'], () ->
  gulp.src path.bower.css.concat ['tmp/css/*']
    .pipe concat 'style.css'
    .pipe gulp.dest 'dist/css/'

gulp.task 'b-copy', () ->
  gulp.src 'app/bower_components/amazeui/fonts/*'
    .pipe gulp.dest 'dist/fonts/'
  gulp.src 'app/img/*'
    .pipe gulp.dest 'dist/img/'
  gulp.src 'app/lib/*'
    .pipe gulp.dest 'dist/lib/'
  gulp.src 'app/views/**/*.html'
    .pipe gulp.dest 'dist/views/'

gulp.task 'b-index', () ->
  opt =
    empty: yes
    spare: yes
    quotes: yes
    conditionals: yes
    comments:yes

  i = Math.round Math.random() * 1000000
  varDic =
    css: "css/style.css?#{i}"
    jsVendor: "js/vendor.js?#{i}"
    jsApp: "js/app.js?#{i}"

  gulp.src 'app/index.html'
    .pipe htmlReplace varDic
    .pipe gulp.dest 'dist/'

gulp.task 't', ['d-app']

gulp.task 'default', ['d-app', 'w-coffee', 'd-css', 'w-less', 'd-pack']
gulp.task 'd', ['d-app', 'd-css', 'd-pack']
build = ['b-app', 'b-vendor', 'b-css', 'b-index', 'b-copy', 'b-pack']
gulp.task 'build', build
gulp.task 'b', build
