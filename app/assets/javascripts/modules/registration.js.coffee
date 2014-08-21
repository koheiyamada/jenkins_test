$ ->
  if $('.registration-form').length
    $('.close-window').on 'click', ->
      window.open('about:blank', '_self').close()
