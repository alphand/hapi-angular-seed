reqdir = require 'require-directory'

class AppRoute
  constructor: (server)->
    @ctrs = reqdir(module,'./app/controllers')
    @routeTables = []
    @setBase()
    @setApp()
    @setStatic()
  setBase: ->
    rtbl = @routeTables
    rtbl.push
      method:'GET'
      path:'/about'
      config: @ctrs.base.about
    
  setApp: ->
    rtbl = @routeTables
    rtbl.push
      method:"GET"
      path:"/"
      handler:
        file:
          path:"./pages/dist/index.html"
    
  setStatic: ->
    rtbl = @routeTables
    rtbl.push
      method:'GET'
      path:'/public/{path*}'
      handler:
        directory:
          path:'./public'
    

module.exports = exports = (server) ->
  approute = new AppRoute(server)
  approute.routeTables
