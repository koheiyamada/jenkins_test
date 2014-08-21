class App.Model.DailyAvailableTime extends Backbone.Model
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

class App.Model.DailyAvailableTimesCache extends Backbone.Model
  available_times_of_days: {}

  getAvailableTimesOfDay: (date, callback)->
    coll = @available_times_of_days[@_dateToKey(date)]
    if coll?
      callback(null, coll)
    else
      @_loadAvailableTimesOfDay(date, callback)

  _loadAvailableTimesOfDay: (date, callback)->
    coll = new App.Collection.DailyAvailableTimeCollection([], date: date, tutor_id: @get('tutor_id'))
    coll.fetch
      success: (collection, response, options)=>
        key = @_dateToKey(date)
        @available_times_of_days[key] = coll
        console.log 'Success'
        callback(null, coll)
      error: (collection, response, options)=>
        console.log 'Error'
        callback('Failed to get data.')

  _dateToKey: (date)->
    date.toLocaleDateString()


class App.Model.TutorAvailableDate extends Backbone.Model
  initialize: ->
    d = @get('date')
    if d
      t = moment(d)
      @date = new Date(t.year(), t.month(), t.date())
    else
      @date = new Date()
