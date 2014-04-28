spawn = require("child_process").spawn

module.exports = exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  
  APP_PATH = "app"
  ASSETS_PATH = "app/assets"
  CLIENT_JS_PATH = "public/scripts"
  PRE_SCRIPT_PATH = "app/assets/prescript" 
  
  grunt.initConfig
    uglify:
      lib:
        options:
          mangle:false
          compress:false
        files:
          './public/scripts/libraries.js':[
            './bower_components/jquery/dist/jquery.js'
            ,'./bower_components/angular/angular.js'
            ,'./bower_components/angular-route/angular-route.js'
          ]
      webapp:
        options:
          mangle:false
          compress:false
        files:
          './public/scripts/vidapp/vidapp.js':[
            './tmp/pre-script/vidapp/vidapp.js'
            ,'./tmp/pre-script/vidapp/vidapp-mods.js'
          ]
    jade:
      server:
        options:
          pretty:true
        files:
          "client-app/dist/index.html":["client-app/src/index.jade"]
      webapp:
        options:
          pretty:true
        files:
          [
            expand:true
            cwd:"./app/assets/client/vidmarket-app/views"
            src:['**/*.jade']
            dest:'./public/scripts/vidapp/views'
            ext:'.html'
          ]
    clean:
      compiled:
        [ '!public/css/fonts'
          , 'public/css/**/*.css'
          , 'public/scripts/**/*.js'
          , 'public/scripts/**/*.html'
        ]
      prescript:[
        './tmp/pre-script'
      ]
    compass:
      dev:
        options:
          sassDir: 'app/assets/scss'
          cssDir: 'public/css'
          noLineComments: true
          outputStyle: "nested"
    coffee:
      vidapp:
        options:
          bare:true
        files:
          "./tmp/pre-script/vidapp/vidapp.js":[
            "#{ASSETS_PATH}/client/vidmarket-app/vidapp.coffee"
          ]
          "./tmp/pre-script/vidapp/vidapp-mods.js":[
            "#{ASSETS_PATH}/client/vidmarket-app/**/*.coffee"
            ,"!#{ASSETS_PATH}/client/vidmarket-app/vidapp.coffee"
          ]
    watch:
      server:
        files:["!./app/assets/**/*",'./app/**/*.coffee']
        tasks:["hapi-restart"]
        options:
          livereload:true
          spawn:false
      webappscript:
        files:["./app/assets/client/vidmarket-app/**/*.coffee"]
        tasks:["coffee:vidapp"]
        options:
          livereload:true
      webappjade:
        files:["./app/assets/client/vidmarket-app/**/*.jade"]
        tasks:["jade:webapp"]
        options:
          livereload:true
      homefile:
        files: ["./client-app/src/**/*.jade"]
        tasks:["jade:server","hapi-restart"]
        options:
          livereload:true
          spawn:false

  grunt.registerTask 'hapi-start', 'Run HAPI Server', ->
    hpserver = spawn('coffee',['main.coffee'],stdio:"inherit")
    grunt.option('hpserver',hpserver)

  grunt.registerTask 'hapi-restart', 'Restart HAPI Server', ->
    hpserver = grunt.option('hpserver')
    hpserver.kill "SIGHUP"
    grunt.task.run 'hapi-start'

  grunt.registerTask 'build-assets', ['clean:compiled','compass:dev','uglify:lib','coffee:vidapp','uglify:webapp','clean:prescript',"jade:webapp"]
  grunt.registerTask 'default', ['build-assets','hapi-start','watch']
  
