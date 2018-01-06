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

const cacheIdentifier = Math.round(+new Date() / 1000) + ".cache";
const config = {
  assetsDir: "files/gerrit/Resources/",
  destinationDir: "files/gerrit/static",
  attributes: "attributes/theme.rb",
  template: "files/gerrit/GerritSiteFooter.html",
  mainCss: "files/gerrit/GerritSite.css",
  sassPattern: "Sass/**/*.scss",
  jsPattern: "JavaScript/**/*.js",
  production: !!util.env.production,
  cacheIdentifier: cacheIdentifier
};

/**
 * Main task
 * Before we start the build process we clean up the old files.
 *
 * @return {void}
 */
gulp.task("default", ["clean-up"], function() {
  gulp.start("build");
});

/**
 * Build task
 * - Compile sass files to css and minify the new css styles
 * - Concatenate the js files and uglify the bundle
 *
 * @return {void}
 */
gulp.task("build", ["build-css", "build-js"], function() {
  gulp.start("update-sources");
});

/**
 * Write new sources task
 * We change the file name of the styles and the js bundle on each build
 * so we need to adjust the includes at some points.
 *
 * - Adjust the attributes for the theme
 * - Include the gerrit css bundle to the static main css file
 * - Load the new js bundle in the footer template
 *
 * @return {void}
 */
gulp.task("update-sources", [
  "write-attributes",
  "write-styles",
  "write-javascript"
]);

/**
 * Handle all the SASS files and compile them to minified css.
 *
 * @return {void}
 */
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

/**
 * Handle all the js files and concat them to a uglified bundle.
 *
 * @return {void}
 */
gulp.task("build-js", function() {
  return gulp
    .src(config.assetsDir + config.jsPattern)
    .pipe(sourcemaps.init())
    .pipe(concat("bundle_" + config.cacheIdentifier + ".js"))
    .pipe(config.production ? uglify() : util.noop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(config.destinationDir));
});

/**
 * Update the theme attributes
 *
 * @return {void}
 */
gulp.task("write-attributes", function() {
  gulp
    .src([config.attributes])
    .pipe(
      replace(
        new RegExp("(gerrit-styles_)\\d{10}.cache.css", "g"),
        "gerrit-styles_" + config.cacheIdentifier + ".css"
      )
    )
    .pipe(
      replace(
        new RegExp("(bundle_)\\d{10}.cache.js", "g"),
        "bundle_" + config.cacheIdentifier + ".js"
      )
    )
    .pipe(
      gulp.dest(function(file) {
        return file.base;
      })
    );
});

/**
 * Update css include
 *
 * @return {void}
 */
gulp.task("write-styles", function() {
  gulp
    .src([config.mainCss])
    .pipe(
      replace(
        new RegExp("(gerrit-styles_)\\d{10}.cache.css", "g"),
        "gerrit-styles_" + config.cacheIdentifier + ".css"
      )
    )
    .pipe(
      gulp.dest(function(file) {
        return file.base;
      })
    );
});

/**
 * Update js include
 *
 * @return {void}
 */
gulp.task("write-javascript", function() {
  gulp
    .src([config.template])
    .pipe(
      replace(
        new RegExp("(bundle_)\\d{10}.cache.js", "g"),
        "bundle_" + config.cacheIdentifier + ".js"
      )
    )
    .pipe(
      gulp.dest(function(file) {
        return file.base;
      })
    );
});

/**
 * Remove all old js bundle and css files.
 *
 * @return {void}
 */
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
