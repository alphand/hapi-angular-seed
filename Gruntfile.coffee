child = require('child_process').spawn

module.exports = exports = (grunt)->
  @options =
    hpserver:null

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    jade:
      indexapp:
        options:
          pretty:true
        files:
          "./client-app/dist/index.html":"./client-app/src/index.jade"
    coffee:
      webapp:
        options:
          bare:true
          joined:true
        files:
          './public/js/pp-acc-app.js':[
            './app/assets/client-app/pp-acc-app.coffee'
            , './app/assets/client-app/**/*.coffee'
          ]
    compass:
      dist:
        options:
          sassDir:"./app/assets/scss"
          cssDir:"./public/css"
    watch:
      hapi:
        files:['!./app/assets/**/*','./app/**/*.coffee']
        tasks: 'restart-hapi'
        options:
          spawn:false

  
  grunt.registerTask 'restart-hapi','restart backend server', ->
    hpserver = grunt.option('hpserver')
    hpserver.kill('SIGHUP')
    grunt.task.run('hapi')

  grunt.registerTask 'hapi','run backend server', ->
    hpserver = child('coffee',['main.coffee'],stdio:'inherit')
    grunt.option('hpserver',hpserver)

  grunt.registerTask('default',['hapi','watch'])
