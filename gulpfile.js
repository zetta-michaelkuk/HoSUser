/* jshint node:true */
'use strict';

require('coffee-script/register');

var
    gulp = require('gulp'),
    jasmine = require('gulp-jasmine'),
    nodemon = require('gulp-nodemon'),
    SpecReporter = require('jasmine-spec-reporter');

gulp.task('test', function() {
    return gulp
        .src('tests/**/*.spec.coffee')
        .pipe(jasmine({
            reporter: new SpecReporter()
        }));
});

gulp.task('nodemon', function() {
    nodemon({
            script: 'index.js',
            ext: 'js coffee',
            ignore: ['node_modules/**/*', 'tests/**/*'],
            tasks: ['test'],
            env: {
                AMQP_URL: 'localhost',
                AMQP_USERNAME: 'guest',
                AMQP_PASSWORD: 'guest'
            }
        })
        .on('restart', function() {
            console.log('restarted!');
        });
});

gulp.task('watch', function() {
    gulp.watch(['tests/**/*.spec.coffee'], ['test']);
});

gulp.task('default', ['watch', 'nodemon']);
