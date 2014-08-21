class App.Collection.DailyAvailableTimeCollection extends Backbone.Collection
  model: App.Model.DailyAvailableTime

  initialize: (models, options)->
    console.log options
    if options?
      @date = options.date
      @tutor_id = options.tutor_id

  url: ->
    "/tutors/#{@tutor_id}/daily_available_times/#{@date.getFullYear()}/#{@date.getMonth() + 1}/#{@date.getDate()}"

class App.Collection.TutorAvailableDateCollection extends Backbone.Collection
  model: App.Model.TutorAvailableDate

  url: ->
    if @tutor_id
      "/tutors/#{@tutor_id}/available_dates"
    else
      'dates'

  initialize: (models, options)->
    @on 'add', @onAdded, @
    if options?
      @tutor_id = options.tutor_id

  onAdded: (d)->
    console.log d
