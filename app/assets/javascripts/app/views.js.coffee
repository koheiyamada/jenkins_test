class App.View.DateSelectorView extends Backbone.View
  el: '.date-select'
  highlight_dates: {}

  initialize: (options)->
    @_initialize(options)

  _initialize: (options)->
    today = new Date()
    @$('.date_picker').datepicker
      onSelect: (dateText, picker)=>
        @onDateSelected(dateText, picker)
        false
      onChangeMonthYear: (year, month)=>
        @onMonthChanged(year, month)
      dateFormat: 'yy/mm/dd'
      minDate: today
      maxDate: @_maxDate()
      defaultDate: @_defaultDate()

  _defaultDate: ->
    dateText = @$('#date').val()
    if dateText && dateText.length > 0
      new Date(dateText)
    else
      new Date()

  _maxDate: -> null

  onDateSelected: (dateText, picker)->
    @$('#date').val(dateText)
    date = new Date(dateText)
    @selectDate(date)
    @highlightMonthDeffered(date.getFullYear(), date.getMonth() + 1)

  onMonthChanged: (year, month)->
    @highlightMonthDeffered(year, month)

  highlightMonthDeffered: (year, month, delay)->
    unless delay?
      delay = 0
    setTimeout((=> @highlightMonth(year, month)), delay)

  highlightMonth: (year, month)->
    console.log "year: #{year}, month: #{month}"
    if @highlight_dates[year]?
      if @highlight_dates[year][month]?
        dates = _.keys(@highlight_dates[year][month])
        @$('.ui-datepicker-calendar td').each (idx, elm)->
          $cell = $(elm)
          $cell.css('position': 'relative')
          d = $cell.text()
          if _.contains(dates, d)
            $wrapper = $('<div>').addClass('tutor-available-date-active')
            $cell.find('a').appendTo($wrapper)
            $cell.prepend($wrapper)

  addHighlightDate: (date)->
    y = date.getFullYear()
    m = date.getMonth() + 1
    d = date.getDate()
    unless @highlight_dates[y]?
      @highlight_dates[y] = {}
    unless @highlight_dates[y][m]?
      @highlight_dates[y][m] = {}
    @highlight_dates[y][m][d] = date

  selectDate: (date)->
    console.log 'selected!'
    @trigger 'selected', date

class App.View.TutorScheduleDateSelectorView extends App.View.DateSelectorView
  initialize: (options)->
    App.View.DateSelectorView.prototype.initialize.apply(@, arguments)
    available_dates = new App.Collection.TutorAvailableDateCollection([], tutor_id: options.tutor_id)
    available_dates.fetch
      success: (coll)=>
        coll.each (model)=>
          @addHighlightDate(model.date)
        m = new Date()
        @highlightMonth(m.getFullYear(), m.getMonth() + 1)

  _maxDate: ->
    m = new Date()
    m.setMonth(m.getMonth() + 3)
    m

class App.View.AvailableTimeView extends Marionette.ItemView
  template: '#available-time-template'
  className: 'available-time'

  serializeData: ->
    if @date
      @_serializeWithDate(@date)
    else
      @_serializeWithoutDate()

  _serializeWithoutDate: ->
    s = @model.getStartAt()
    e = @model.getEndAt()
    {
    date: "#{s.getFullYear()}-#{s.getMonth() + 1}-#{s.getDate()}"
    start_at: AID.formatTime(s)
    end_at: AID.formatTime2(e, s.getDate() != e.getDate())
    is_new: @model.isNew()
    }

  _serializeWithDate: (date)->
    s = @model.getStartAt()
    unless AID.sameDate(s, date)
      s = AID.beginningOfDay(date)
    e = @model.getEndAt()
    {
    date: "#{date.getFullYear()}-#{date.getMonth() + 1}-#{date.getDate()}"
    start_at: AID.formatTime(s)
    end_at: AID.formatTime2(e, s.getDate() != e.getDate())
    is_new: @model.isNew()
    }

  _padZero: (n)->
    ('00' + n).slice(-2)

class App.View.EmptyAvailableTimesView extends Marionette.ItemView
  template: '#empty-available-times-template'

class App.View.AvailableTimesOfDayView extends Marionette.CollectionView
  className: 'available_times-of-selected-day'
  itemView: App.View.AvailableTimeView
  emptyView: App.View.EmptyAvailableTimesView

  initialize: (options)->
    @date = options.date

  onBeforeItemAdded: (itemView)->
    itemView.date = @date
