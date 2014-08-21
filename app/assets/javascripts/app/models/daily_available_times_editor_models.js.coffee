class DailyAvailableTimesEditor.Model.DailyAvailableTime extends Backbone.Model
  initialize: ->
    @start_at = new Date(@get('start_at'))
    @end_at = new Date(@get('end_at'))

  isOverlapping: (other)->
    @start_at < other.end_at && @end_at > other.start_at

  getDuration: ()->
    Math.floor((@end_at - @start_at) / 60000)

  getStartAt: ->
    @start_at

  getEndAt: ->
    @end_at

  getDates: ->
    end_at = new Date(@end_at.getTime() - 1)
    @dates ||= AID.uniqueDates([@start_at, end_at])

  isAcrossDays: ->
    @start_at.getDate() != @end_at.getDate() ||
    @start_at.getMonth() != @end_at.getMonth() ||
    @start_at.getFullYear() != @end_at.getFullYear()

  # 日付ごとに分割したDailyAvailableTimeの配列を返す。
  splitByDay: ->
    _.map @getDates(), (day)=> @_availableTimeOfDay(day)

  _availableTimeOfDay: (day)->
    t1 = AID.beginningOfDay(day)
    t2 = AID.beginningOfDay(AID.nextDate(day))
    if t1 < @start_at
      t1 = @start_at
    if t2 > @end_at
      t2 = @end_at
    new DailyAvailableTimesEditor.Model.DailyAvailableTime(day: day, start_at: t1, end_at: t2)


class DailyAvailableTimesEditor.Collection.AvailableTimeCollection extends Backbone.Collection
  model: DailyAvailableTimesEditor.Model.DailyAvailableTime

  initialize: (models, options)->
    console.log options
    @on 'add', @onAdded, @
    @on 'remove', @onRemoved, @
    if options?
      @date = options.date

  url: ->
    throw new Exception('Not implemented')

  onAdded: (model)->
    console.log "Added! #{model}"

  onRemoved: (model)->
    console.log "Removed! #{model}"


class DailyAvailableTimesEditor.Collection.DailyAvailableTimeCollection extends DailyAvailableTimesEditor.Collection.AvailableTimeCollection
  url: ->
    "#{@date.getFullYear()}/#{@date.getMonth() + 1}/#{@date.getDate()}"


class DailyAvailableTimesEditor.Collection.AvailableTimesOfMonthCollection extends Backbone.Collection
  url: ->
    "#{@date.getFullYear()}/#{@date.getMonth() + 1}"


class DailyAvailableTimesEditor.Model.Editor extends Backbone.Model
  defaults:
    'selected_day': new Date()
    'selected_time_range': null

  available_times_to_delete: null
  available_times_to_add: null
  available_times: null

  initialize: ->
    @available_times_to_delete = new DailyAvailableTimesEditor.Collection.DailyAvailableTimeCollection()
    @available_times_to_add = new DailyAvailableTimesEditor.Collection.DailyAvailableTimeCollection()
    @available_times = new DailyAvailableTimesEditor.Util.TutorDailyAvailableTimes(@get('selected_day'))
    @on 'change:selected_time_range', @onTimeRangeChanged, @

  hasChanges: ->
    @available_times_to_add.length > 0 || @available_times_to_delete.length > 0

  saveChanges: ->
    if @hasChanges()
      data =
        add: @available_times_to_add.map (item)->item.attributes
        delete: @available_times_to_delete.map (item)->item.attributes
      console.log data
      AID.showWaitScreen()
      $.post('update_all.json', data)
      .done (res)=>
          console.log 'success'
          @clearChanges()
          location.reload()
      .fail (res)=>
          error_messages = res.responseJSON.error_messages
          console.log error_messages
          console.log 'Fail'
          AID.hideWaitScreen()

  clearChanges: ->
    @available_times_to_add.reset([])
    @available_times_to_delete.reset([])

  getAvailableTimesOfDay: (date, callback)->
    @available_times.getDataOfDate date, (err, coll)=>
      callback(err, coll)

  getAvailableTimesOfDays: (dates, callback)->
    unique_dates = AID.uniqueDates(dates)
    @available_times.getDataOfDates unique_dates, (err, ts)=>
      if err
        callback(err)
      else
        callback(null, ts)

  selectDate: (date)->
    @set 'selected_day', date
    @available_times.getDataOfDate date, (err, ts)=>
      if err
        console.error err
      else
        @trigger 'date:selected', date, ts
    console.log "date selected #{date}"

  onTimeRangeChanged: ->
    r = @get('selected_time_range')
    console.log "#{r.start_time.hour}:#{r.start_time.minute} - #{r.end_time.hour}:#{r.end_time.minute}"

  createDailyAvailableTime: ->
    console.log 'Start creating'
    day = @get('selected_day')
    r   = @get('selected_time_range')
    # 時間データは現地時刻になっている
    range = @_createTimeRange(day, r)
    available_time = new DailyAvailableTimesEditor.Model.DailyAvailableTime(start_at: range.start_at.getTime(), end_at: range.end_at.getTime())
    @_validateNewAvailableTime available_time, (err)=>
      if err
        @trigger 'validation:error', err.error_messages
        console.log err
      else
        @available_times.add(available_time)
        @available_times_to_add.add(available_time)

  _validateNewAvailableTime: (available_time, callback)->
    day = available_time.start_at
    errors = []
    if available_time.getDuration() < @get('minimum_time_range')
      errors.push 'too_short'
    # 日をまたぐ時間帯とも比較するために、前後の日のデータとも比較する。
    if available_time.isAcrossDays()
      days = [AID.prevDate(day), day, AID.nextDate(day)]
    else
      days = [AID.prevDate(day), day]
    @getAvailableTimesOfDays days, (err, ts)=>
      if ts.any((t)=> t.isOverlapping(available_time))
        errors.push 'overlapping'
      if errors.length > 0
        callback(error_messages: errors)
      else
        callback(null)

  _createTimeRange: (day, r)->
    s = new Date(day.getFullYear(), day.getMonth(), day.getDate(), r.start_time.hour, r.start_time.minute)
    e = new Date(day.getFullYear(), day.getMonth(), day.getDate(), r.end_time.hour, r.end_time.minute)
    if s > e
      e.setDate(e.getDate() + 1)
    {start_at: s, end_at: e}

  deleteDailyAvailableTime: (available_time)->
    console.log 'Pushing to delete!'
    if available_time.isNew()
      available_time.destroy()
    else
      @available_times_to_delete.add(available_time)
      console.log 'Available time marked to delete'


class DailyAvailableTimesEditor.Model.TimeRange
  start_time:
    hour: 0
    minute: 0
  end_time:
    hour: 0
    minute: 0

  constructor: (h1, m1, h2, m2)->
    if h1? && m1? && h2? && m2?
      @start_time.hour = h1
      @start_time.minute = m1
      @end_time.hour = h2
      @end_time.minute = m2

class DailyAvailableTimesEditor.Util.TutorDailyAvailableTimes
  _data: null
  tutor_id: null

  constructor: (date)->
    @_data = {}
    @_loadDataOfMonth date, (err)->
      if err
        console.error err
      else
        console.log '------------------------------------------ Data is Ready!!!!!!'

  _urlOfDataOfMonth: (date)->
    "/tu/daily_available_times/#{date.getFullYear()}/#{date.getMonth() + 1}"

  getDateOfMonth: (date, callback)->
    @_loadDataOfMonth date, (err)->
      if err
        callback(err)
      else
        month_key = AID.dateToMonthString(date)
        callback(null, @_data[month_key])

  _loadDataOfMonth: (date, callback)->
    month_key = AID.dateToMonthString(date)
    if @_data[month_key]
      callback(null)
    else
      @_data[month_key] = {}
      $.getJSON(@_urlOfDataOfMonth(date))
        .done (list)=>
          ts = _.map list, (attr)=>
            new DailyAvailableTimesEditor.Model.DailyAvailableTime(attr)
          _.each ts, (t)=>
            @add(t)
          callback(null, ts)
        .fail (res)=>
          console.error res

  add: (t)->
    dates = t.getDates()
    console.log "Dates = #{dates}"
    _.each dates, (date)=>
      @getDataOfDate date, (err, coll)=>
        if err
          console.error err
        else
          coll.add t

  getDataOfDate: (date, callback)->
    @_getDataOfMonth date, (err, monthly_data)=>
      d = date.getDate()
      if monthly_data[d]
        callback null, monthly_data[d]
      else
        monthly_data[d] = new DailyAvailableTimesEditor.Collection.DailyAvailableTimeCollection()
        callback null, monthly_data[d]

  getDataOfDates: (dates, callback)->
    @_collectDataOfDates(dates, new DailyAvailableTimesEditor.Collection.DailyAvailableTimeCollection(), callback)

  _collectDataOfDates: (dates, ts, callback)=>
    if dates.length == 0
      callback(null, ts)
    else
      date = _.first(dates)
      @getDataOfDate date, (err, coll)=>
        ts.add(coll.models)
        @_collectDataOfDates(_.rest(dates), ts, callback)

  _getDataOfMonth: (date, callback)->
    m = AID.dateToMonthString(date)
    if @_data[m]
      callback(null, @_data[m])
    else
      @_loadDataOfMonth date,(err, list)=>
        if err
          callback(err)
        else
          callback(null, @_data[m])
