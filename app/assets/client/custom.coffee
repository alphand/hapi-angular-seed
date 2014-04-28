$(document).ready( ->
  $('.animated').each((i)->
    $this = $(this)
    animated = $this.data('animated')
    setTimeout( ->
      $this.addClass(animated)
    ,100*i)
  )
)
