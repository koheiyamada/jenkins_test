$ ->
  if $("#lesson-room").length
    $room = $("#lesson-room")
    lessonId = parseInt $room.attr("data-lesson_id")
    if $room.hasClass "lesson-room-for-student"
      $room.for_student = true
    else if $room.hasClass "lesson-room-for-tutor"
      $room.for_tutor = true

    # 現在ページを開いているユーザー
    currentUser =
      id: parseInt $room.attr "data-user_id"
      role: $room.attr 'data-user_type'
      isTutor: ->
        $room.hasClass "lesson-room-for-tutor"
      isStudent: ->
        $room.hasClass "lesson-room-for-student"
      isWatcher: ->
        @role == 'hq_user' || @role == 'bs_user'

      checkIn: (lesson)->
        lesson.checkIn this, (err)=>
          if err
            console.log "Failed to check in!"
          else
            console.log "Succeeded to check in!"
            @notify type:'MEMBER_CHECKED_IN', user:this

      help: ->
        @notify type:"HELP", user:this

      notify: (params)->
        socket = window.getSocket && window.getSocket()
        if socket
          if socket.isReady
            socket.emit "NOTIFY", params, (err)->
              if err
                console.log "Failed to notify: #{err}"
                alert err if err
              else
                console.log "Successfully notified #{params.type}"
            console.log "Notified #{params.type}"
          else
            console.log "Socket is not ready"
        else
          console.log 'Failed to notify!'

    #
    # Lesson: 授業データ
    #
    class Lesson extends Backbone.Model
      startedAt: null
      endedAt: null
      timeLessonEnd: null
      timeDoorOpen: null
      timeDoorClose: null
      timeToCheckLessonExtension: null
      timeRoomClose: null
      updatedAt: null

      initialize: (options)->
        _.bindAll this
        @on 'change:started_at', @onStarted
        @on 'change:status', @onStatusChanged
        @startTime = parseISO8601 @get("start_time")
        @endTime   = parseISO8601 @get("end_time")
        @_parseTimeFields()
        @timers = {}
        @resetTimers()

      _updateTimeFields: (lesson)->
        @startedAt     = parseISO8601 lesson.started_at
        @endedAt       = parseISO8601 lesson.ended_at
        @timeLessonEnd = parseISO8601 lesson.time_lesson_end
        @timeDoorOpen  = parseISO8601 lesson.time_door_open
        @timeDoorClose = parseISO8601 lesson.time_door_close
        @timeToCheckLessonExtension = parseISO8601 lesson.time_to_check_lesson_extension
        @timeRoomClose = parseISO8601 lesson.time_room_close
        @updatedAt     = parseISO8601 lesson.updated_at
        @dropoutClosingTime = parseISO8601(lesson.dropout_closing_time)

      _parseTimeFields: ()->
        @_updateTimeFields(@attributes)

      resetTimers: ->
        console.log 'タイマー一式を再設定します。'
        #now = new Date(new Date().getTime() - 75 * 60 * 1000)
        # すでにタイマーがセットアプされている場合はそれらをクリアする。
        _.each @timers, (timerId)=> clearTimeout(timerId)
        @timers = {}

        now = new Date()

        console.log "現在時刻:                       now = #{now}"
        console.log "レッスン終了時刻: this.timeLessonEnd = #{@timeLessonEnd}"
        console.log "入室制限時刻:     this.timeDoorClose = #{@timeDoorClose}"
        console.log "最終退室時刻:     this.timeRoomClose = #{@timeRoomClose}"
        console.log "延長確認時刻: this.timeToCheckLessonExtension = #{@timeToCheckLessonExtension}"
        console.log "中止制限時刻: this.dropoutClosingTime = #{@dropoutClosingTime}"

        # レッスン終了時刻
        if @timeLessonEnd && !@timers["timeLessonEnd"] && @timeLessonEnd > now
          @timers["timeLessonEnd"] =
            setTimeout (=> @trigger "time:end"), @timeLessonEnd - now
          console.log "レッスン終了時刻：" + Math.floor((@timeLessonEnd - now) / 60000) + "分後"

        # 入室制限時刻
        if @timeDoorClose && !@timers["timeDoorClose"] && @timeDoorClose > now
          @timers["timeDoorClose"] =
            setTimeout (=> @trigger "time:door_close"), @timeDoorClose - now
          console.log "入室制限時刻：" + Math.floor((@timeDoorClose - now) / 60000) + "分後"

        # 最終締め出し時刻
        if @timeRoomClose && !@timers["timeRoomClose"] && @timeRoomClose > now
          @timers["timeRoomClose"] =
            setTimeout (=> @trigger "time:close_room"), @timeRoomClose - now
          console.log "最終退出時刻：" + Math.floor((@timeRoomClose - now) / 60000) + "分後"

        # 延長確認時刻
        if @timeToCheckLessonExtension && !@timers["timeToCheckLessonExtension"] && @timeToCheckLessonExtension > now
          @timers["timeToCheckLessonExtension"] =
            setTimeout (=> @trigger('time:check_lesson_extension')), @timeToCheckLessonExtension - now
          console.log "延長確認時刻：" + Math.floor((@timeToCheckLessonExtension - now) / 60000) + "分後"

        # 中止制限時刻
        if @dropoutClosingTime && !@timers["@dropoutClosingTime"] && @dropoutClosingTime > now
          @timers['dropoutClosingTime'] =
            setTimeout (=> @trigger('time:dropout_closing_time')), @dropoutClosingTime - now
          console.log "中止制限時刻：" + Math.floor((@dropoutClosingTime - now) / 60000) + "分後"

      onStarted: ->
        @_parseTimeFields()
        @resetTimers()

      startable: -> !@startedAt?

      stoppable: ->
        # 授業が開催中 && 授業終了時間を過ぎている
        !!(@startedAt && !@endedAt && (new Date() > @timeLessonEnd))

      extendable: ->
        if @get("extended") || @get("extension_enabled")
          false
        else
          !!@get("extendable")

      isStarted: -> @startedAt?

      isDone: -> @get('status') == 'done'

      isAttendedMember: (user)->
        if @get('attended_member_ids')
          _.include(@get('attended_member_ids'), user.id)
        else
          false

      doorClosed: ->
        if @timeDoorClose
          new Date() > @timeDoorClose
        else
          false

      dropoutClosed: ->
        @dropoutClosingTime? && new Date() > @dropoutClosingTime

      # レッスンを開始する
      # これを呼ぶのはチューターのみ
      open: (params)->
        $.post("open", params)
          .done (data)=>
            # 授業が開始することで確定する各種時刻の設定
            @_updateTimeFields(data)
            # 内部状態もまとめて更新
            @set(data)
            # タイマーを設定する
            @resetTimers()
            @trigger("started") # これはチューターにしか伝わらないイベント。生徒はstarted_atを監視する
          .fail ->
            alert "Failed to start the lesson."

      # レッスンを終了する
      # これを呼ぶのはチューターのみ
      close: (params)->
        $.post("close", params)
          .done (data)=>
            @endedAt = parseISO8601(data.ended_at)
            @set(data)
          .fail (data)=>
            console.log "Failed to stop the lesson."
          .always (data)=>
            @trigger("ended") # これはチューターにしか伝わらないイベント。生徒はended_atを監視する

      # レッスンに参加する
      checkIn: (user, callback)->
        now = new Date()
        if now < @checkInLimitTime()
          $.post("check_in.json")
          .done (data)=>
            @_updateTimeFields(data) # 授業が開始することで確定する各種時刻の設定
            @set(data) # 内部状態もまとめて更新
            @resetTimers() # タイマーを再設定する
            if callback
              callback(null)
            console.log 'Succeeded to check in'
          .fail (err)=>
            console.log 'Failed to check in'
            if callback
              callback(err)
        else
          console.log "User #{user.id} tried to check in to lesson #{@get('id')} at #{now} after the check in limit time"

      checkInLimitTime: -> @timeDoorClose

      # 最新のデータを取得する
      updateState: ->
        @fetch
          success: (lesson)-> lesson._parseTimeFields()

      # サーバのレッスンデータが更新されているかチェックする
      checkUpdate: (callback)->
        $.get('updated_at.json')
        .done (data)=>
          t1 = parseISO8601 data.updated_at
          updated = t1? && t1 > @updatedAt
          callback(updated) if callback

      # 更新がある場合のみ最新のデータを取得する
      updateState2: ->
        @checkUpdate (updated)=>
          if updated
            @updateState()

      onMemberCheckedIn: (user)->
        console.log "Member checked in #{user && user.id}"
        if currentUser.id != user.id
          @updateState() # 状態を更新する
          #alert("Member checked in #{user && user.id}")

      # 延長可能かどうかチェックする
      # TODO: 生徒がこれを呼ばないようにする
      checkIfExtendable: ->
        $.getJSON("extendable.json")
          .done (result)=>
            @set("extendable", result.extendable)
            @trigger('extendability_checked', result)
          .fail (e)=>
            console.log e

      # チューターがレッスンの延長を可能にする
      enableExtension: (params)->
        $.ajax(
          type: "POST"
          url: "enable_extension"
          data: params
          success: (data)=>
            @set(data)
          error: (data)=>
            alert "Failed to enable extension."
        )

      # 生徒がレッスンの延長を申し込む
      createExtensionRequest: (params)->
        $.post('extension_request.json', params)
          .done (data)=>
            extensionRequest = new LessonExtensionRequest(data)
            @trigger 'extension:request_created', extensionRequest
            console.log 'Succeeded to apply extension.'
          .fail (res)=>
            console.log 'Failed to apply extension.'
            data = $.parseJSON(res.responseText)
            if data.error_messages
              console.log error_message for error_message in data.error_messages
            @trigger 'extension_request:error', data

      # チューターがレッスンの延長を実行する
      executeExtension: ->
        token = $("head > meta[name='csrf-token']").attr('content')
        $.post('extension.json', authenticity_token:token)
          .done (data)=>
            console.log 'レッスンを延長できました', data
            @_updateTimeFields(data)
            # 内部状態もまとめて更新
            @set(data)
            @trigger 'extension:extended'
          .fail (res)=>
            console.log 'レッスンを延長できませんでした'
            if res.responseText
              res = $.parseJSON(res.responseText)
            @trigger 'extension:failed', res

      # 他の参加者からヘルプが届いた
      onHelp: (user)->
        @trigger "help", user

      # 生徒がレッスンを途中退席する（オプションレッスンのみ）
      leave: (user)->
        if @isStarted()
          @_leave(user, !true)
          .then(
            (res)=>
              if res.success
                @trigger 'studentLeft', user
                @notify type: 'STUDENT_CANCELLED', user: user
              else
                throw new Error(res.error_message)
            (xhr, status, err)=>
              console.error('Failed to post leave.json')
              throw err)
        else
          $.Deferred().reject(message: 'Lesson is not started yet.').promise()

      _leave: (user, test=false)->
        if test
          $.Deferred().resolve(success: 1).promise()
        else
          $.post("leave.json")

      # 生徒がレッスンを途中退席する（オプションレッスンのみ）
      accept_cancellation: (user)->
        $.post("students/#{user.id}/dropout.json")
          .done (res)=>
            if res.success
              @trigger "studentLeft", user
              window.getSocket().emit("NOTIFY", type:"CANCEL_REQUEST_ACCEPTED", user:user)
              if res.remaining_student_count == 0
                console.log 'すべての受講者が退室しました。'
            else
              console.log res.error_messages
              @trigger 'dropout:failed', user: user, errorMessages: res.error_messages
              window.getSocket().emit("NOTIFY", type:"CANCEL_REQUEST_FAILED", user:user, errorMessages: res.error_messages)
          .fail (res)=>
            console.log '受講者の途中キャンセルができませんでした。'
            console.log res
            alert '受講者の途中キャンセルができませんでした。'

      notify: (params)->
        socket = window.getSocket()
        if socket
          socket.emit 'NOTIFY', params

      # チューターにキャンセルリクエストを出す
      requestToCancel: (user)->
        window.getSocket().emit "NOTIFY", {type:"REQUEST_CANCEL", user:user}

      onCancelRequested: (user)->
        @trigger "cancel_requested", user

      onStudentCancelled: (user)->
        @trigger "student_cancelled", user

      onCancelRequestRejected: (user)->
        @trigger "cancel_request_rejected", user

      onCancelRequestAccepted: (user)->
        @trigger "cancel_request_accepted", user

      onCancelRequestFailed: (user, errorMessages)->
        @trigger "cancel_request_failed", user, errorMessages

      onExtensionRequested: (user)->
        @trigger 'extension:requested', user

      onOutdated: ->
        @updateState()

      onStatusChanged: ->
        console.log "状態が変化しました: #{@get('status')}"
        if @isDone()
          console.log "レッスンが終了しました。"
          @trigger 'ended'

      isTimeOver: ->
        @timeLessonEnd && @timeLessonEnd < new Date()

    # 延長可能かどうかを表すデータ
    class LessonExtendability extends Backbone.Model

    # 受講者の延長申込データ
    class LessonExtensionRequest extends Backbone.Model


    #
    # LessonControlView: 授業の開始・停止ボタン
    #
    class LessonControlView extends Backbone.View
      events:
        "click .start": "startLesson"
        "click .stop": "stopLesson"

      initialize: (options)->
        _.bindAll(this);
        @model.on "change", @render
        @model.on "time:end", @onEndTime
        @model.on "time:close_room", @onRoomClose
        @model.on "ended", @onEnded
        @render()

      render: ->
        @$(".start").toggle @model.startable()
        @$(".stop").show()
        @$(".stop").attr "disabled", !@model.stoppable()
        @$(".enable-extension").toggle @model.extendable()
        #@$(".apply-extension").toggle(@model.extendable())
        @

      # レッスンに「参加」したことにする
      #
      # 参加予定メンバー全員が揃うとレッスンが「開始状態」に移行する
      # 'start'といういかにもレッスンが始まりそうな名前になっているが、
      # 画面の仕様がそうなっているからであって、実際にレッスンが開始するのは
      # チューターと生徒全員が「スタート」を押し終えた時である。
      startLesson: (e)->
        @$(".start").attr "disabled", true
        token = $("head > meta[name='csrf-token']").attr 'content'
        currentUser.checkIn @model
        @render()

      # レッスンを終了する。
      # サーバにレッスンの終了を伝達し、結果を受け取った後画面をリロードして
      # レッスン終了後の画面を表示する。
      stopLesson: (e)->
        @$(".stop").attr("disabled", true)
        token = $("head > meta[name='csrf-token']").attr 'content'
        @model.close(authenticity_token:token)

      onEndTime: ->
        console.log "onEndTime called at " + new Date()
        # 通知する？
        @$(".stop").attr("disabled", false)

      onRoomClose: ->
        console.log "onRoomClose called at " + new Date()

      onEnded: ->
        location.reload()


    class StudentActionsView extends Backbone.View
      events:
        'click .help': 'help'
        'click .start': 'start'

      initialize: ->
        _.bindAll(this, 'render')
        @model.on('change:attended_member_ids', @render)
        @render()

      render: ->
        attended = @model.isAttendedMember(currentUser)
        @$('.start').toggle(!attended)

      start: ->
        currentUser.checkIn(@model)
        #@$('.start').attr('disabled', true)

      help: ->
        currentUser.help()


    # レッスンの経過時間を扱う
    class LessonElapsedTimeCounter extends Backbone.Model
      initialize:(options)->
        @lesson = options.lesson
        if @lesson.isStarted()
          @start()
        else
          @listenTo @lesson, 'change:started_at', @start

      start: ->
        # タイマーを開始する。タイマーは1秒経過するたびにupdateを呼び出す
        # 経過時間の起点となる時刻は引数または現在時刻
        console.log "Elapsed time is starting: startAt:#{@lesson.startedAt}, startTime:#{@lesson.startTime}"
        t = if @lesson.startedAt > @lesson.startTime
              console.log "Lesson started after the start time: #{@lesson.startedAt}"
              @lesson.startedAt
            else
              console.log "Lesson started before the start time: #{@lesson.startedAt}"
              @lesson.startTime
        if t
          @set
            "startTime": t
            "timerId": setInterval(
              ()=> @update()
              1000)

      update: ->
        if @get("startTime")
          @set "elapsedTime", new Date() - @get("startTime")

      isTimeOver: ->
        @lesson.isTimeOver()

    #
    # 経過時間のビュー
    #
    class LessonElapsedTimeView extends Backbone.View
      initialize: ->
        # changeイベントごとにビューを更新する
        @listenTo @model, 'change:elapsedTime', @render
        @_updateStyle()

      render: ->
        @_renderTime()
        @_updateStyle()

      _renderTime: ->
        # 開始時刻からの経過時間を表示する
        elapsedTime = @model.get("elapsedTime")
        if elapsedTime?
          elapsedTimeInSeconds = Math.floor(Math.abs(elapsedTime) / 1000)
          elapsedTimeInMinutes = Math.floor(elapsedTimeInSeconds / 60)
          sec = elapsedTimeInSeconds % 60
          min = elapsedTimeInMinutes % 60
          hour = (elapsedTimeInMinutes - min) / 60
          time = "#{hour}:#{("00" + min).slice(-2)}:#{("00" + sec).slice(-2)}"
          if elapsedTime < 0
            time = '-' + time
          @$el.html time

      _updateStyle: ->
        @$el.toggleClass 'is-over', @model.isTimeOver()

    #
    #
    #
    class LessonExtendabilityCheckable extends Backbone.View
      extendability: null

      _updateExtendability: (callback)->
        $.getJSON('extendability.json')
          .done (data)=>
            @extendability = new LessonExtendability(data)
            if callback
              callback(null, @extendability)
          .fail (res)=>
            console.log 'Failed to update the lesson extendability'
            if callback
              callback(res)

      updateExtendability: ->
        @_updateExtendability (err, extendability)=>
          if err
            console.log 'Failed to update extendability'
          else
            console.log 'Succeeded to update extendability'
            unless extendability.get('extendable')
              @showReasonsForNotExtendable(extendability.get 'reasons')
            @render()
            console.log '延長用ビューを更新しました。'

      showReasonsForNotExtendable: (messages)->
        @$('.reasons').text messages.join(', ')

    #
    # レッスン延長情報ビュー（チューター専用）
    #
    class LessonExtensionView extends LessonExtendabilityCheckable
      events:
        'click .check-if-extendable': 'checkIfExtendable'
        'click .update-extendability': 'updateExtendability'
        'click .extend-lesson': 'extendLesson'

      extensionRequested: false

      initialize: ->
        _.bindAll(this)
        @model.on 'change:started_at', @checkIfExtendable
        @model.on 'change:extended', @onLessonExtended
        @model.on 'extendability_checked', @onExtendabilityChecked
        @model.on 'extension:requested', @onExtensionRequested
        @model.on 'extension:extended', @onLessonExtended
        @model.on 'extension:failed', @onExtensionFailed
        @checkIfExtensionRequestsComplete()
        @render()

      # 参加者「全員」がレッスン延長を申し込んだかどうかをチェックする
      checkIfExtensionRequestsComplete: ->
        $.getJSON('extension_requests/complete.json')
          .done (data)=>
            @extensionRequested = data
            if @extensionRequested
              console.log '参加中の全受講者からレッスンの延長申込があります。'
            else
              console.log '参加中の全受講者からはレッスンの延長を申し込まれていません。'
            @render()
          .fail (res)=>
            console.log "レッスンの延長申込状況を取得できませんでした: #{res.status}"

      render: ->
        if @model.get('extended')
          @changeState('is-extended')
        else if @extensionRequested
          @changeState('is-extension-requested')
        else if @extendability?
          if @extendability.get 'extendable'
            @changeState 'is-extendable'
          else
            @changeState 'is-not-extendable'
        else
          @changeState 'is-default'

      checkIfExtendable: (e)->
        @model.checkIfExtendable()

      onExtendabilityChecked: (result)->
        if result.extendable
          console.log 'Lesson is extendable!'
          @changeState 'is-extendable'
          @$('.message').text(result.message)
        else
          console.log "Lesson is not extendable because #{result.reason}"
          @$(".message").text(result.reason)

      onExtensionRequested: (user)->
        console.log "レッスン延長が申し込まれました: user:#{user.id}"
        @checkIfExtensionRequestsComplete()

      onExtensionFailed: (res)->
        console.log 'レッスンを延長できませんでした。'
        if res.error_messages
          @showErrorMessages(res.error_messages)

      showErrorMessages: (messages)->
        if messages
          @$('.error-messages').text messages.join(', ')
          @$('.error-message-dialog').modal(backdrop:false)

        # レッスンが延長された
      onLessonExtended: ->
        if @model.get("extended")
          @changeState("is-extended")
        @model.resetTimers() # 終了時刻が変わるのでタイマーを設定し直す必要がある。
        console.log "レッスンが延長されました"

      changeState: (newState)->
        @$el.removeClass("is-default")
        @$el.removeClass("is-extendable")
        @$el.removeClass("is-not-extendable")
        @$el.removeClass("is-extension-requested")
        @$el.removeClass("is-extended")
        @$el.addClass(newState)

      extendLesson: ->
        console.log '延長実行ボタンを押しました'
        @model.executeExtension()

    #
    # レッスン延長申込（受講者画面だけで使用する）
    #
    class LessonExtensionRequestView extends LessonExtendabilityCheckable
      events:
        'click .create-extension-request': 'createExtensionRequest'
        'click .update-extendability': 'updateExtendability'

      extensionRequest:null

      initialize: ->
        _.bindAll(this)
        @model.on 'change:extended', @onLessonExtended
        @model.on 'extendability_checked', @onExtendabilityChecked
        @model.on 'extension_request:error', @onExtensionRequestFailed
        @model.on 'time:check_lesson_extension', @onTimeToCheckLessonExtension
        @model.on 'extension:request_created', @onExtensionRequestCreated
        $.getJSON('extension_request.json')
          .done (data)=>
            # 延長申込をすでにしている状態の場合
            @extensionRequest = new LessonExtensionRequest(data)
            console.log 'extensionRequest initialized'
            @render()
          .fail (response)=>
            # 延長申込をしていない状態の時はサーバが404を返すのでこの処理が呼ばれる。
            console.log 'extensionRequest not initialized'
            console.log response.status
            if @model.timeToCheckLessonExtension && new Date() > @model.timeToCheckLessonExtension
              @updateExtendability()
            @render()

      render: ->
        if @model.get 'extended'
          @changeState 'is-extended'
        else if @extensionRequest
          @changeState 'is-waiting-for-extension'
        else if @extendability?
          if @extendability.get 'extendable'
            @changeState 'is-extendable'
          else
            @changeState 'is-not-extendable'
        else
          @changeState 'is-default'

      onTimeToCheckLessonExtension: ->
        # レッスンが延長可能かチェックして、ビューを更新する
        console.log "triggered LessonExtensionRequestView#onTimeToCheckLessonExtension"
        @updateExtendability()

      onExtensionRequestCreated: (extension_request)->
        console.log 'レッスンの延長申込が正常に完了しました。'
        @changeState('is-waiting-for-extension')
        currentUser.notify type:'EXTENSION_REQUESTED', user:currentUser

      onExtensionRequestFailed: (data)->
        if data.error_messages
          @showReasonsForNotExtendable(data.error_messages)
        @changeState('is-not-extendable')

      onExtendabilityChecked: (result)->
        if result.extendable
          console.log "Lesson is extendable!"
          @$(".enable-extension").attr("disabled", false)
          @$(".message").text(result.message)
        else
          console.log "Lesson is not extendable because #{result.reason}"
          @$(".message").text(result.reason)

      # レッスンが延長された
      onLessonExtended: ->
        if @model.get("extended")
          @changeState("is-extended")
        @model.resetTimers() # 終了時刻が変わるのでタイマーを設定し直す必要がある。
        console.log "レッスンが延長されました"

      changeState: (newState)->
        @$el.removeClass("is-default")
        @$el.removeClass("is-extendable")
        @$el.removeClass("is-not-extendable")
        @$el.removeClass("is-extended")
        @$el.removeClass("is-waiting-for-extension")
        @$el.addClass(newState)

      createExtensionRequest: (e)->
        token = $("head > meta[name='csrf-token']").attr('content')
        @model.createExtensionRequest(authenticity_token:token)


    #
    # タイムスケジュールビュー
    #
    class LessonTimeScheduleView extends Backbone.View
      el: $(".lesson-time-schedule", $room)

      initialize: ->
        _.bindAll(this)
        @model.on("change:started_at", @render)
        @model.on("change:extended", @render)

      render: ->
        @$el.load "time_schedule", ->
          console.log "Time Schedule Updated"


    #
    # 生徒用のレッスン状態監視用
    #
    class LessonMonitorForStudent extends Backbone.View
      el: $(".lesson-monitor-for-student", $room)
      interval: 10000

      initialize: ->
        # レッスンの終了を監視する
        @listenTo @model, "change:ended_at", @onEndedAtChanged
        # ポーリング開始
        @timer = setInterval (=> @run()), @interval

      run: ->
        @model.updateState2()

      onEndedAtChanged: ->
        if @model.isDone()
          location.reload()

    #
    # 途中退室用ビュー
    #
    class LessonLeaveView extends Backbone.View
      events:
        'click a': 'onButtonClicked'

      initialize: (options)->
        @user = options.user
        @listenTo @model, 'time:dropout_closing_time', @onDropoutClosingTime
        @listenTo @model, 'change:started_at',         @onStarted
        @listenTo @model, 'cancel_request_accepted',   @onCancelRequestAccepted
        @listenTo @model, 'cancel_request_rejected',   @onCancelRequestRejected
        @listenTo @model, 'cancel_request_failed',     @onCancelRequestFailed
        # すでに入室制限時刻を過ぎていれば表示しない
        @render()

      onCancelRequestRejected: (user)->
        if user.id == @user.id
          console.log "レッスンのキャンセルが断られました。"
          alert "レッスンのキャンセルが断られました。"

      onCancelRequestAccepted: (user)->
        if user.id == @user.id
          console.log "レッスンのキャンセルに成功しました。"
          location.href = "left"

      onCancelRequestFailed: (user, errorMessages)->
        if user.id == @user.id
          console.log "レッスンのキャンセルに失敗しました。"
          if errorMessages
            alert 'キャンセルできませんでした：\n' + errorMessages.join("\n")

      onDropoutClosingTime: ->
        @disable()

      disable: ->
        @$el.addClass 'disabled'
        @$('a').addClass 'disabled'

      onStarted: ->
        @show()

      onButtonClicked: (e)->
        e.preventDefault()
        @dropoutFromLesson()

      dropoutFromLesson: ->
        unless @model.dropoutClosed()
          if confirm('本当にレッスンを中止してもよいですか？')
            @model.leave(@user)
            .done ()=>
              location.href = 'left'
            .fail (err)=>
              console.error(err.message)
              alert(err.message)
          else
            console.log 'レッスン中止を取りやめました'

      requestToCancelLesson: ->
        unless @model.dropoutClosed()
          if confirm('本当にレッスンを中止してもよいですか？')
            @model.requestToCancel(@user)
          else
            console.log 'キャンセルしました。'

      show: ->
        @$el.parent("section").show()

      hide: ->
        @$el.parent("section").hide()

      render: ->
        #@$el.parent("section").toggle(@shouldShowLeavePanel())
        @show()
        if @model.dropoutClosed()
          @disable()

      shouldShowLeavePanel: ->
        if @model.isStarted()
          if @model.dropoutClosed()
            false
          else
            true
        else
          false


    #
    # LessonRoomView
    #
    class LessonRoomView extends Backbone.View
      el: $("#lesson-room")

      events:
        "click .update-lesson-extension": "updateLesson"
        "mouseover .desk-switch": "clearHelp"
        "click .popover": "clearHelp"

      initialize: (options)->
        _.bindAll(this)
        @model.on "studentLeft", @onStudentLeft
        @model.on 'dropout:failed', @onDropoutFailed
        @model.on "cancel_requested", @onCancelRequested
        @model.on "student_cancelled", @onStudentCancelled
        @model.on "change:started_at", @onLessonStarted
        @model.on "help", @onHelp
        @desks_view = new DesksView(el: @$('.desks'))
        @$(".desk-switch").popover
          title: ""
          content: "呼び出し中"
          trigger: "manual"
          delay:
            show:300, hide:500
          placement:'bottom'

      updateLesson: ->
        @model.updateState()
        false

      onLessonStarted: ->
        console.log "Started!"

      onStudentLeft: (user)->
        console.log "#{user.id} Left!!!"

      onDropoutFailed: (params)->
        user = params.user
        errorMessages = params.errorMessages
        if user
          console.log "#{user.id} failed to dropout."
        if errorMessages
          alert 'キャンセルできませんでした：\n' + errorMessages.join("\n")

      onCancelRequested: (user)->
        if currentUser.isTutor()
          $(".cancel-requested[data-student_id='#{user.id}']").modal()

      # 受講者がレッスンをキャンセルした
      onStudentCancelled: (user)->
        if currentUser.isTutor()
          $(".student-cancelled[data-student_id='#{user.id}']").modal()

      onHelp: (user)->
        @$(".desk-switch.student-#{user.id}").addClass("help").popover("show")

      clearHelp: ->
        @$(".desk-switch").removeClass('help').popover('hide')

    #
    #
    #
    class DesksView extends Backbone.View
      initialize: ->
        # creating sub views
        @desk_tabs = @$('.desk-pane').map -> new DeskTabView(el: $(@))
        @desk_switcher = new DeskSwitcher(el: @$('.desk-switcher'))
        # connecting each other
        @listenTo @desk_switcher, 'desk_switched', @onDeskSwitched
        # initializing sub views
        @onDeskSwitched()

      getSize: ->
        width: @$el.outerWidth()
        height: @$el.outerHeight()

      getActiveDeskTab: ->
        _.find @desk_tabs, (view)=> view.isActive()

      onDeskSwitched: ->
        desk_tab = @getActiveDeskTab()
        if desk_tab?
          desk_tab.onShow()

    #
    #
    #
    class DeskTabView extends Backbone.View
      initialize: ->
        @desk_view = new DeskView(el: @$('.desk'))

      isActive: ->
        @$el.hasClass('active')

      onShow: ->
        @desk_view.onShow()


    #
    #
    #
    class DeskSwitcher extends Backbone.View
      events:
        'shown .desk-switch a': 'onDeskSwitched'

      initialize: ->

      onDeskSwitched: (e)->
        target = $(e.target).attr('data-target')
        @trigger 'desk_switched', target

    #
    # LessonCancelDialogView
    #
    class LessonCancelDialogView extends Backbone.View
      events:
        "click .accept": "accept"
        "click .reject": "reject"

      initialize: ->
        @user = id: parseInt(@$el.attr("data-student_id"))

      accept: ->
        @model.accept_cancellation(@user)
        @$el.modal("hide")

      reject: ->
        window.getSocket().emit "NOTIFY", {type:"CANCEL_REQUEST_REJECTED", user:@user}
        @$el.modal('hide')


    class Clock
      constructor: (@el)->
        @timer = setInterval((=> @render()), 1000)

      render: ->
        now = new Date()
        h = now.getHours()
        m = ('0' + now.getMinutes()).slice(-2)
        time = "#{h}:#{m}"
        @el.text(time)

    #
    # VideoView
    #
    class VideoView extends Backbone.View
      events:
        "hover": "clearHelp"

      initialize: (options)->
        @user = options.user
        @lesson = options.lesson
        _.bindAll(this)

      clearHelp: ->
        @$el.removeClass("help")
        @$el.popover('hide')


    #
    #
    #
    class MessageView extends Backbone.View
      events:
        "click .close_button": "hide"
      initialize: ->
        _.bindAll(this)
        @model.on "change:started_at", @render
        unless @model.isStarted()
          @show()

      render: ->
        if @model.isStarted()
          @hide()

      hide: ->
        @$el.hide()

      show: ->
        @$el.show()

    #
    #
    #
    class LessonMonitorForWatcher extends Backbone.View
      interval: 20000

      initialize: ->
        @listenTo @model, 'change:ended_at', @onLessonEnded
        @timer = setInterval(
          ()=> @checkUpdate()
          @interval)
        console.log 'MONITOR: Start to watch the lesson.'

      checkUpdate: ->
        @model.checkUpdate (updated)=>
          if updated
            console.log 'MONITOR: lesson updated'
            @model.updateState()
          else
            console.log 'MONITOR: lesson not updated'

      updateLesson: ->
        @model.updateState()
        console.log "MONITOR: lesson updated at #{new Date()}"

      onLessonEnded: ->
        location.reload()



    # 通知領域にメッセージを追加する
    addNotification = (message)->
      $("<p>").text(new Date().toString() + ": " + message).appendTo($(".lesson-notifications", $room))

    #
    # 初期化するために授業データをサーバからロードする
    #
    $.getJSON "../#{lessonId}.json", (data)->
      # レッスンモデル
      lesson = new Lesson(data)
      lesson.url = "../#{lessonId}.json"

      # レッスン開始からの経過時間表示
      elapsedTimeCounter = new LessonElapsedTimeCounter(lesson:lesson)
      timerView = new LessonElapsedTimeView(el:$(".lesson-elapsed-time"), model:elapsedTimeCounter)

      # レッスンに関するの各時間の情報のビュー
      new LessonTimeScheduleView(model:lesson)

      # 生徒固有の処理
      if currentUser.isStudent()
        new LessonMonitorForStudent(model: lesson, el: $(".lesson-monitor-for-student", $room))
        new LessonLeaveView(el:$(".lesson-leave", $room), model:lesson, user:currentUser)
        #new StudentActionsView(el:$(".student-actions", $room), model:lesson)
        new StudentActionsView(el:$(".student-actions"), model:lesson)
        new LessonExtensionRequestView(el:$('.lesson-extension-request'), model:lesson)
        currentUser.checkIn(lesson) # 自動的にスタートしたのと同じ扱い

      # チューター固有の処理
      if currentUser.isTutor()
        $(".cancel-requested").each ->
          new LessonCancelDialogView(el:$(this), model:lesson)
        # チューター向けのレッスン操作ビュー
        new LessonControlView(el:$(".lesson-control"), model:lesson, user:currentUser)
        new MessageView(el: $(".lesson-message"), model: lesson)
        # レッスン延長に関するビュー
        new LessonExtensionView(el: $('.lesson-extension', $room), model: lesson)
        currentUser.checkIn(lesson) # 自動的にスタートしたのと同じ扱い

      # 監視者固有の処理
      if currentUser.isWatcher()
        new LessonMonitorForWatcher(model: lesson, el: $('#lesson-room'))

      # 各局所的なビューに収まらない処理を扱う
      new LessonRoomView(model:lesson, user:currentUser)

      new Clock($('.lesson-clock'))

      # デバッグ用途にレッスンデータに直接アクセスする手段
      window.getLesson = -> lesson

      # 映像
      $(".video", $room).each ->
        user_id = parseInt($(this).attr("data-user_id"))
        new VideoView(user:{id:user_id}, lesson:lesson, el:$(this))
