$ ->

#  if $('.tutor-daily-available-times-widget').length
#
#    class DailyAvailableTime extends Backbone.Model
#      initialize: ->
#        @start_at = new Date(@get('start_at'))
#        @end_at = new Date(@get('end_at'))
#
#      isOverlapping: (other)->
#        @start_at < other.end_at && @end_at > other.start_at
#
#      getDuration: ()->
#        Math.floor((@end_at - @start_at) / 60000)
#
#      getStartAt: ->
#        @start_at
#
#      getEndAt: ->
#        @end_at
#
#    class DailyAvailableTimeCollection extends Backbone.Collection
#      model: DailyAvailableTime
#
#      initialize: (models, options)->
#        console.log options
#        if options?
#          @date = options.date
#          @tutor_id = options.tutor_id
#
#      url: ->
#        "/tutors/#{@tutor_id}/daily_available_times/#{@date.getFullYear()}/#{@date.getMonth() + 1}/#{@date.getDate()}"
#
#    class DailyAvailableTimesCache extends Backbone.Model
#      available_times_of_days: {}
#
#      getAvailableTimesOfDay: (date, callback)->
#        coll = @available_times_of_days[@_dateToKey(date)]
#        if coll?
#          callback(null, coll)
#        else
#          @_loadAvailableTimesOfDay(date, callback)
#
#      _loadAvailableTimesOfDay: (date, callback)->
#        coll = new DailyAvailableTimeCollection([], date: date, tutor_id: @get('tutor_id'))
#        coll.fetch
#          success: (collection, response, options)=>
#            key = @_dateToKey(date)
#            @available_times_of_days[key] = coll
#            console.log 'Success'
#            callback(null, coll)
#          error: (collection, response, options)=>
#            console.log 'Error'
#            callback('Failed to get data.')
#
#      _dateToKey: (date)->
#        date.toLocaleDateString()
#
#
#    class DateSelectorView extends Backbone.View
#      el: '.date-select'
#
#      initialize: (options)->
#        today = new Date()
#        @$('.date_picker').datepicker
#          onSelect: (dateText, picker)=>
#            @onDateSelected(dateText, picker)
#            false
#          dateFormat: 'yy-mm-dd'
#          minDate: today
#          defaultDate: @_defaultDate()
#
#      _defaultDate: ->
#        dateText = @$('#date').val()
#        if dateText && dateText.length > 0
#          new Date(dateText)
#        else
#          new Date()
#
#      onDateSelected: (dateText, picker)->
#        @$('#date').val(dateText)
#        @selectDate(new Date(dateText))
#
#      selectDate: (date)->
#        console.log 'selected!'
#        @trigger 'selected', date
#
#    class AvailableTimeView extends Marionette.ItemView
#      template: '#available-time-template'
#      className: 'available-time'
#
#      serializeData: ->
#        s = @model.getStartAt()
#        e = @model.getEndAt()
#        {
#        date: "#{s.getFullYear()}-#{s.getMonth() + 1}-#{s.getDate()}"
#        start_at: @_formatTime(s)
#        end_at: @_formatTime(e)
#        is_new: @model.isNew()
#        }
#
#      _formatTime: (t)->
#        "#{@_padZero(t.getHours())}:#{@_padZero(t.getMinutes())}"
#
#      _padZero: (n)->
#        ('00' + n).slice(-2)
#
#    class EmptyAvailableTimesView extends Marionette.ItemView
#      template: '#empty-available-times-template'
#
#    class AvailableTimesOfDayView extends Marionette.CollectionView
#      className: 'available_times-of-selected-day'
#      itemView: AvailableTimeView
#      emptyView: EmptyAvailableTimesView
#
#    #
#    #
#    #
#
#    app = new Marionette.Application()
#
#    app.addRegions
#      available_times_of_day_region: '#available_time_of_day-region'
#
#    app.addInitializer (options)->
#      tutor_id = $('.tutor-daily-available-times-widget').attr('data-tutor_id')
#      DailyAvailableTime.prototype.urlRoot = 'tutor_daily_available_times'
#      date_selector = new DateSelectorView()
#      #time_selector = new TimeSelectorView()
#      daily_available_times = new DailyAvailableTimesCache(tutor_id: tutor_id)
#      #buttons_view = new ButtonsView()
#
#      @listenTo date_selector, 'selected', (date)->
#        daily_available_times.getAvailableTimesOfDay date, (err, available_times)=>
#          view = new AvailableTimesOfDayView(collection: available_times, model: daily_available_times)
#          @available_times_of_day_region.show(view)
#
#      now = new Date()
#      console.log now
#      date_selector.selectDate(new Date(now.getFullYear(), now.getMonth(), now.getDate()))
#
#    app.start()
