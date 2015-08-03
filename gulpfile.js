
// Include plugins
var gulp = require('gulp'),
    gutil = require('gulp-util'),
    sass = require('gulp-sass'),
    prefix = require('gulp-autoprefixer'),
    coffee = require('gulp-coffee'),
    coffeelint = require('gulp-coffeelint'),
    concat = require('gulp-concat'),
    plumber = require('gulp-plumber'),
    changed = require('gulp-changed'),
    uglify = require('gulp-uglify');

var options = {
    // HTML
    // HTML_SOURCE     : "views/**/*.tpl",

    // CSS
    SASS_SOURCE     : "./source/stylesheets/**/*.sass",
    SASS_DEST       : "./build/stylesheets/",

    // JavaScript
    COFFEE_SOURCE   : "./source/javascripts/**/*.coffee",
    COFFEE_DEST     : "./build/assets/js/",

    // Images
    IMAGE_SOURCE    : "./source/images/**/*",
    IMAGE_DEST      : "./build/assets/images/",

    // Live reload
    LIVE_RELOAD_PORT: 35729
};

// Compile SASS
gulp.task('sass', function() {
    gulp.src( options.SASS_SOURCE )
        .pipe(plumber())
        .pipe(sass({
            outputStyle: 'compressed',
            // sourceComments: 'map'
            }))
        .on("error", notify.onError())
        .on("error", function (err) {
            console.log("Error:", err);
        })
        .pipe(prefix(
            "last 2 versions", "> 10%"
            ))
        .pipe(gulp.dest( options.SASS_DEST ))
        .pipe(livereload(server));
});

// Compile Coffee
gulp.task('coffee', function () {
  gulp.src( options.COFFEE_SOURCE )
    .pipe(changed ( options.COFFEE_SOURCE ))
    .pipe(coffee({
        sourceMap: true
    })
    .on('error', gutil.log))
    .pipe(gulp.dest( options.COFFEE_DEST ))
    .pipe(livereload(server));
});


gulp.task('default', ['sass','coffee']); // and so on...
