Hapi = require "hapi"
config = require './app/config/settings'

class Server
  constructor: ->
    @server = Hapi.createServer('0.0.0.0',config.port,config.hapi.options)
    @setPlugins()
    @setRoute()  
  start: ->
    @server.start( ->
      console.log "HAPI Server is started on 0.0.0.0:#{config.port}"
    )
  stop: (cb)->
    @server.stop(->
      console.log("HAPI Server stopped")
      cb()
    )
  setPlugins: ->
    plugins = require('./app/config/plugins')(@server)
  setRoute: ->
    routes = require('./app/routes')(@server)
    @server.route(routes)


module.exports = exports = Server
