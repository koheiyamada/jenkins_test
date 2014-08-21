$ ->

  $('.widget[data-delayed_load]').each ->
    $holder = $(@)
    path = $holder.attr('data-delayed_load')
    setTimeout((=> $holder.load(path)), 1000)
