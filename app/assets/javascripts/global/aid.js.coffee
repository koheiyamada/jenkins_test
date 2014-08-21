$ ->
  _.extend AID,

    startWaiting: (callback)->
      @showWaitScreen()
      timer = setInterval(callback, 1000)
      @stopWaiting = ->
        clearInterval(timer)
        @hideWaitScreen()

    stopWaiting: -> # デフォルトでは何もしない

    showWaitScreen: ->
      $('#wait-screen').modal(backdrop: 'static')

    hideWaitScreen: ->
      $('#wait-screen').modal('hide')

    showErrorMessages: (errorMessages)->
      html = $('#templates .error_messages').html()
      hoge = _.template(html, error_messages: errorMessages)
      $('.error-messages-holder').html hoge
      console.log errorMessages if window.console

    savePreference: (key, value)->
      $.cookie key, value

    getPreference: (key)->
      $.cookie key

    getMessage: (message_id)->
      $("##{message_id}").text().trim()

    padZero: (number)->
      ('00' + number).slice(-2)

    formatTime: (t, next_day)->
      h = if next_day then t.getHours() + 24 else t.getHours()
      "#{AID.padZero(h)}:#{AID.padZero(t.getMinutes())}"

    formatTime2: (t, next_day)->
      if next_day
        h = 24
        m = 0
      else
        h = t.getHours()
        m = t.getMinutes()
      "#{AID.padZero(h)}:#{AID.padZero(m)}"

    uniqueDates: (dates)->
      _.reduce dates, ((result, date)=>
        unless _.any result, ((d)=> AID.sameDate(d, date))
          result.push date
        result
      ), []

    sameDate: (date1, date2)->
      date1.getFullYear() == date2.getFullYear() &&
      date1.getMonth() == date2.getMonth() &&
      date1.getDate() == date2.getDate()

    dateToMonthString: (date)->
      "#{date.getFullYear()}-#{date.getMonth()}"

    prevDate: (date)->
      new Date(date.getFullYear(), date.getMonth(), date.getDate() - 1)

    nextDate: (date)->
      new Date(date.getFullYear(), date.getMonth(), date.getDate() + 1)

    beginningOfDay: (date)->
      new Date(date.getFullYear(), date.getMonth(), date.getDate())

    resetFileField: ($field)->
      $field.wrap('<form>').closest('form').get(0).reset()
      $field.unwrap()
