spawn = require("child_process").spawn

module.exports = exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  
  APP_PATH = "app"
  ASSETS_PATH = "app/assets"
  CLIENT_JS_PATH = "public/scripts"
  PRE_SCRIPT_PATH = ".tmp/prescript" 
  NG_APP_PATH = "app/assets/client-app/"
  
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
          './public/scripts/app/pp-acc-app.js':[
            "#{PRE_SCRIPT_PATH}/client-app/pp-acc-app.ngmin.js"
          ]
    jade:
      server:
        options:
          pretty:true
        files:
          "pages/dist/index.html":["pages/src/index.jade"]
      webapp:
        options:
          pretty:true
        files:
          [
            expand:true
            cwd:"#{NG_APP_PATH}/views"
            src:['**/*.jade']
            dest:'./public/scripts/app/views'
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
        "#{PRE_SCRIPT_PATH}"
      ]
    compass:
      dev:
        options:
          sassDir: 'app/assets/scss'
          cssDir: 'public/css'
          noLineComments: true
          outputStyle: "nested"
    coffee:
      ngapp:
        options:
          bare:true
        files:
          ".tmp/prescript/client-app/pp-acc-app.js":[
            "#{ASSETS_PATH}/client-app/pp-acc-app.coffee"
            , "#{ASSETS_PATH}/client-app/**/*.coffee"
          ]
    ngmin:
      ngapp:
        src:["#{PRE_SCRIPT_PATH}/client-app/pp-acc-app.js"]
        dest:"#{PRE_SCRIPT_PATH}/client-app/pp-acc-app.ngmin.js"
    watch:
      server:
        files:["!./app/assets/**/*",'./app/**/*.coffee']
        tasks:["hapi-restart"]
        options:
          livereload:true
          spawn:false
      webappscript:
        files:["#{NG_APP_PATH}/**/*.coffee"]
        tasks:["build-ngapp"]
        options:
          livereload:true
      webappjade:
        files:["#{NG_APP_PATH}/**/*.jade"]
        tasks:["jade:webapp"]
        options:
          livereload:true
      homefile:
        files: ["./pages/src/**/*.jade"]
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

  grunt.registerTask 'build-ngapp',['clean:prescript','coffee:ngapp','ngmin:ngapp','uglify:webapp','jade:webapp', 'clean:prescript']
  grunt.registerTask 'build-assets', ['clean:compiled','compass:dev','uglify:lib']
  grunt.registerTask 'default', ['build-assets','build-ngapp','jade:server','hapi-start','watch']
