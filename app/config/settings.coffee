
settings =
  root:process.cwd()
  port:parseInt(process.env.PORT,10) || 6100
  hapi:
    options:
      views:
        path:"./app/views"
        engines:
          html: 'jade'

module.exports = exports = settings
