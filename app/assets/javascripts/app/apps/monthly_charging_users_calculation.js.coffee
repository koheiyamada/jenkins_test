class AID.App.MonthlyChargingUsersCalculation
  constructor: ($elm)->
    @year = $elm.attr('data-year')
    @month = $elm.attr('data-month')
    $('.btn', $elm).on 'click', => @start()

  run: ->

  start: ->
    AID.showWaitScreen()
    $.post("#{@month}/calculate.json")
    .done (job)=>
        console.log job
        @startMonitoring(job.id)
    .fail (res)=>
        console.log res

  startMonitoring: (job_id)->
    console.log "job_id = #{job_id}"
    timer_id = setInterval((=>
      $.get("#{@month}/job.json?job_id=#{job_id}")
        .done (res)=>
          console.log 'success'
          console.log res
          if res.status == 'done'
            @stopMonitoring(timer_id)
            location.reload()
        .fail (res)=>
          console.log 'failure'
          console.log res
          @stopMonitoring(timer_id)
    ), 3000)

  stopMonitoring: (timer_id)->
    clearInterval(timer_id)
    AID.hideWaitScreen()
