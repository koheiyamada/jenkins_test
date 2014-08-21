$ ->
  if $('.lesson-list').length
    renderCancelSelectedButton = ->
      count = $('input:checked').length
      if count > 0
        $('input:submit').attr('disabled': false)
      else
        $('input:submit').attr('disabled': true)

    $('input:checkbox').on 'click', (e)->
      renderCancelSelectedButton()

    renderCancelSelectedButton()
