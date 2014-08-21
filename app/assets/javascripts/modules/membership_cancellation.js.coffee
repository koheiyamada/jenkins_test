$ ->
  $('.new_membership_cancellation').each ->
    $form = $(@)
    $btn = $form.find('input[type="submit"]', $form)
    $btn.click (e)->
      e.preventDefault()
      if confirm $btn.attr('data-confirm')
        $.post($form.attr('action') + '.json', $form.serialize())
          .done (data)=>
            # 結果待ちモードに移行する
            startWaiting()
          .fail (data)=>
            console.log "Failed to leave: status: #{data.status}"
            if data.status == 422
              res = $.parseJSON data.responseText
              showErrorMessages res.error_messages
            else
              showErrorMessages ['Error']
      false
    path = $form.attr('action')
    pathOnCreated = $form.attr('data-path-on-created') || '/left'

    startWaiting = ->
      showWaitScreen()
      $form.waitTimer = setInterval(checkMembershipCancellationStatus, 1000)

    stopWaiting = ->
      clearInterval($form.waitTimer)
      hideWaitScreen()

    showWaitScreen = ->
      $('#wait-screen').modal()

    hideWaitScreen = ->
      $('#wait-screen').modal('hide')

    checkMembershipCancellationStatus = ->
      path = $form.attr('action')
      $.get(path + '.json')
        .done (data)=>
          switch data.status
            when 'new'
              # wait more
              console.log '.' if window.console
            when 'done'
              #stopWaiting()
              goToPage(pathOnCreated)
            when 'error'
              stopWaiting()
              showErrorMessages data.error_messages
        .fail (res)=>
          switch res.status
            when 404
              console.log '.' if window.console
            when 401
              # 退会が完了した
              goToPage(pathOnCreated)
            else
              # サーバ側のエラー
              stopWaiting()
              console.log "ERROR: ${res.status}" if window.console

    goToLeftPage = ->
      location.href = '/left'

    goToPage = (path)->
      location.href = path

    showErrorMessages = (errorMessages)->
      html = $('#templates .error_messages').html()
      hoge = _.template(html, error_messages: errorMessages)
      $('.error-messages-holder').html hoge
      console.log errorMessages if window.console
