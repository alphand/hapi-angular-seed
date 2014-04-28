module.exports = 
  index:
    handler:(req,rep)->
      rep.view "base/index"
  about:
    handler:(req,rep) ->
      rep "About me sixthteenth?"

