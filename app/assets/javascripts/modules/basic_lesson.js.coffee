class BasicLessonClosingView extends Backbone.View
  events:
    'click .close-button': 'onButtonClicked'

  initialize: (params)->
    {@interval} = params
    @interval = 5000 unless @interval?
    @confirmation = @$el.attr('data-confirm')
    @redirectUrl = @$el.attr('data-redirect_url')

  onButtonClicked: (e)->
    e.preventDefault()
    unless @isRunning()
      if confirm(@confirmation)
        AID.showWaitScreen()
        @execute()
        .then(
          ()=>
            location.href = @redirectUrl || '..'
          (err)=>
            @_stopWatching()
            AID.hideWaitScreen()
            errorMessages = [err.message]
            AID.showErrorMessages(errorMessages))

  execute: ->
    $.post('close')
    .then(
      ()=> @_startWatching()
      (xhr, status, err)=> err)

  _startWatching: ->
    d = $.Deferred()
    @timer = setInterval(
      ()=>
        $.get('status.json')
        .then(
          (res)=>
            if res.status == 'closed'
              d.resolve()
          (xhr, status, err)=>
            d.reject(err))
      @interval)
    d.promise()

  isRunning: ->
    @timer?

  _stopWatching: ->
    if @timer?
      clearInterval(@timer)
      @timer = undefined

$ ->
  if $('#basic_lesson_info-closing').length
    new BasicLessonClosingView(interval: 3000, el: $('#basic_lesson_info-closing'))

