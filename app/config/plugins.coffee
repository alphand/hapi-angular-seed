
class PPPlugins
  constructor:(server) ->
    @server = server
    @setGood()
  setGood: ->
    goodOpts =
      subscribers:
        'console': ['ops','request','log','error']
        '.tmp/logs/':['ops','request','log','error']

    @server.pack.require('good',goodOpts,(err)->
      console.log "Failed loading GOOD plugins" if err?
    )
module.exports = exports = (server)->
  plugin = new PPPlugins(server)
