$ ->
  if $('.lesson-room-entrance').length
    $entrance = $('.lesson-room-entrance')
    unless window.console
      window.console = (args)->
    if $entrance.attr('data-open_at')
      now = Date.now()
      open_at = Date.parse($entrance.attr('data-open_at'))
      console.log open_at
      console.log now
      if open_at > now
        console.log "1"
        delay = open_at - now
        console.log "delay = #{delay}"
        if delay < 1000 * 60 * 60 * 24
          openDoor = ->
            #$('.enter_room', $entrance).attr('disabled', false)
            console.log "2"
            location.reload()
            #clearTimeout($entrance.timer)
          $entrance.timer = setTimeout(openDoor, delay + 5000)
