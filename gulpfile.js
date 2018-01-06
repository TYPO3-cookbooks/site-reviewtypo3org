/* file: gulpfile.js */

var gulp = require("gulp"),
  sass = require("gulp-sass"),
  concat = require("gulp-concat"),
  uglify = require("gulp-uglify"),
  minifyCSS = require("gulp-minify-css"),
  util = require("gulp-util"),
  rename = require("gulp-rename"),
  replace = require("gulp-string-replace"),
  del = require("del"),
  sourcemaps = require("gulp-sourcemaps");

var config = {
  assetsDir: "files/gerrit/Resources/",
  destinationDir: "files/gerrit/static",
  attributes: "attributes/theme.rb",
  template: "files/gerrit/GerritSiteFooter.html",
  mainCss: "files/gerrit/GerritSite.css",
  sassPattern: "Sass/**/*.scss",
  jsPattern: "JavaScript/**/*.js",
  production: !!util.env.production,
  cacheIdentifier: Math.round(+new Date() / 1000) + ".cache"
};

gulp.task("default", ["clean-up", "build-css", "build-js", "write-attributes"]);

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

gulp.task("write-attributes", function() {
  gulp
    .src([config.attributes])
    .pipe(replace("bundle.js", "bundle_" + config.cacheIdentifier + ".js"))
    .pipe(
      replace(
        "gerrit-styles.css",
        "gerrit-styles_" + config.cacheIdentifier + ".css"
      )
    )
    .pipe(
      gulp.dest(function(file) {
        return file.base;
      })
    );
});

gulp.task("clean-up", function() {
  return del([
    "files/gerrit/static/gerrit-styles_*.cache.css",
    "files/gerrit/static/bundle_*.cache.js"
  ]);
});

/* updated watch task to include sass and js */

gulp.task("watch", function() {
  gulp.watch(config.assetsDir + config.sassPattern, ["build-css"]);
});
