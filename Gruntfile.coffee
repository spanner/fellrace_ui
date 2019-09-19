path = require('path')

config = (grunt) ->

  copy:
    html:
      files: [
        expand: true
        cwd: 'source/'
        src: ['*.html']
        dest: 'dist/'
      ]

    fonts:
      files: [
        expand: true
        cwd: 'source/fonts/'
        src: ['**/*']
        dest: 'dist/fonts/'
      ]

    images:
      files: [
        expand: true
        cwd: 'source/images/'
        src: ['**/*']
        dest: 'dist/images/'
      ]

  sass:
    dist:
      options:
        trace: true
        style: 'nested'
        lineNumbers: true
      files:
        'dist/stylesheets/sis.css': 'source/stylesheets/sis.sass'
        'dist/stylesheets/dl.css': 'source/stylesheets/dl.sass'
        'dist/stylesheets/icons.css': 'source/stylesheets/icons.sass'

  haml:
    compile:
      options:
        target: "js"
        language: "coffee"
        namespace: "FellRace.Templates"
        includePath: true
        pathRelativeTo: './source/javascripts/templates'
      files: 'dist/javascripts/templates.js': './source/javascripts/templates/**/*.haml'

  cssmin:
    compress:
      files:
        'dist/stylesheets/app.css': ['dist/stylesheets/app.css']
      options:
        keepSpecialComments: 0

  mince:
    main:
      options:
        include: ["source/javascripts/fell_race", "node_modules"]
      files: [
        src: "source/javascripts/fr.coffee"
        dest: "dist/javascripts/fr.js"
      ]

  concat:
    options:
      separator: ';'
    dist:
      src: ["dist/javascripts/fr.js", "dist/javascripts/templates.js"]
      dest: 'dist/javascripts/index.js',

  watch:
    options:
      livereload: true
    haml:
      files: ['source/javascripts/templates/**/*.haml']
      tasks: ['haml:compile', 'concat']
    coffee:
      files: ['source/javascripts/**/*.coffee']
      tasks: ['mince:main', 'concat']
    sass:
      files: ['source/stylesheets/**/*.sass']
      tasks: ['sass']
      options:
        spawn: true
    img:
      files: ['source/images/**/*']
      tasks: ['copy:images']
    fonts:
      files: ['source/fonts/**/*']
      tasks: ['copy:fonts']
    html:
      files: ['source/*.html']
      tasks: ['copy:html']


module.exports = (grunt) ->

  grunt.initConfig(config(grunt))

  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-watch')
  # grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-connect')
  # grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-mincer')
  grunt.loadNpmTasks('grunt-haml')

  grunt.registerTask('default', ['build'])

  grunt.registerTask('build', [
    'copy'
    'haml'
    'mince'
    'concat'
    'sass'
    # 'browserify:development'
    # 'cssmin'
  ])

  grunt.registerTask('server', [
    'copy:js'
    'haml'
    'connect:web'
  ])

  # grunt.registerTask("dev", ['browserify:development']);
  # grunt.registerTask("prod", ['browserify:production']);

