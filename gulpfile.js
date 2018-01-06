/* file: gulpfile.js */

var gulp = require("gulp"),
  sass = require("gulp-sass"),
  concat = require('gulp-concat'),
  uglify = require('gulp-uglify'),
  minifyCSS = require('gulp-minify-css'),
  util = require('gulp-util'),
  rename = require('gulp-rename'),
  sourcemaps = require("gulp-sourcemaps");


var config = {
  assetsDir: 'files/gerrit/Resources/',
  destinationDir: 'files/gerrit/static',
  sassPattern: 'Sass/**/*.scss',
  jsPattern: 'JavaScript/**/*.js',
  production: !!util.env.production,
  cacheIdentifier: Math.round(+new Date()/1000) + '.cache'
};

gulp.task("default", ["build-css", "build-js"]);

gulp.task("build-css", function() {
  return gulp
    .src(config.assetsDir + config.sassPattern)
    .pipe(sourcemaps.init())
    .pipe(sass())
    .pipe(rename("gerrit-styles_" + config.cacheIdentifier + ".css"))
    .pipe(config.production ? minifyCSS() : util.noop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(config.destinationDir));
});

gulp.task("build-js", function() {
  return gulp
    .src(config.assetsDir + config.jsPattern)
    .pipe(sourcemaps.init())
    .pipe(concat("bundle_" + config.cacheIdentifier + ".js"))
    .pipe(config.production ? uglify() : util.noop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(config.destinationDir));
});

/* updated watch task to include sass and js */

gulp.task("watch", function() {
  gulp.watch(config.assetsDir + config.sassPattern, ["build-css"]);
});
