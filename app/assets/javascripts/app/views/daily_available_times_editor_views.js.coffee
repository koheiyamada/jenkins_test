class DailyAvailableTimesEditor.View.AvailableTimeView extends Marionette.ItemView
  template: '#available-time-template'
  className: ->
    if @model.isNew()
      'available-time new'
    else
      'available-time'

  events:
    'click .delete-button': 'onDeleteButtonClicked'

  serializeData: ->
    @_viewDataOfModel(@model)

  _viewDataOfModel: (model)->
    s = model.getStartAt()
    e = model.getEndAt()
    date = @date || s
    unless AID.sameDate(date, s)
      s = AID.beginningOfDay(date)
    date: "#{date.getFullYear()}-#{date.getMonth() + 1}-#{date.getDate()}"
    start_at: AID.formatTime(s)
    end_at: AID.formatTime2(e, s.getDate() != e.getDate())
    is_new: model.isNew()

  _padZero: (n)->
    ('00' + n).slice(-2)

  onDeleteButtonClicked: (e)->
    @trigger 'delete'

class DailyAvailableTimesEditor.View.AvailableTimeToAddView extends DailyAvailableTimesEditor.View.AvailableTimeView
  template: '#available-time-template2'

  initialize: (params, options)->
    super
    # model : DailyAvailableTime
    # 表示用に日付ごとに分割する（日をまたがないものは要素１つの配列になる）
    @collection = new Backbone.Collection(@model.splitByDay())

  serializeData: ->
    s = @model.getStartAt()
    e = @model.getEndAt()
    start_date = "#{s.getFullYear()}-#{s.getMonth() + 1}-#{s.getDate()}"
    unless AID.sameDate(s, e)
      end_date = "#{e.getFullYear()}-#{e.getMonth() + 1}-#{e.getDate()}"
    start_date: start_date
    start_at:   AID.formatTime(s)
    end_date:   end_date
    end_at:     AID.formatTime(e)


class DailyAvailableTimesEditor.View.EmptyAvailableTimesView extends Marionette.ItemView
  template: '#empty-available-times-template'


class DailyAvailableTimesEditor.View.AvailableTimesOfDayView extends Marionette.CollectionView
  className: 'available_times-of-selected-day'
  itemView: DailyAvailableTimesEditor.View.AvailableTimeView
  emptyView: DailyAvailableTimesEditor.View.EmptyAvailableTimesView

  initialize: (options)->
    @date = options.date
    @on 'itemview:delete', @deleteItem, @

  deleteItem: (itemView)->
    console.log @collection.length
    available_time = itemView.model
    @collection.remove available_time
    @model.deleteDailyAvailableTime(available_time)
    console.log @collection.length

  onBeforeItemAdded: (itemView)->
    itemView.date = @date

  itemAdded: (itemView)->
    console.log 'ItemAdded!!'


class DailyAvailableTimesEditor.View.DateSelectorView extends App.View.TutorScheduleDateSelectorView
  selectDate: (date)->
    @model.selectDate(date)


class DailyAvailableTimesEditor.View.TimeSelectorView extends Backbone.View
  el: '.time-select'

  events:
    'change select': 'onTimeChanged'
    'click button': 'onAddButtonClicked'

  initialize: ->
    @model.set('selected_time_range', new DailyAvailableTimesEditor.Model.TimeRange())
    @render()

  render: ->
    r = @model.get('selected_time_range')
    @$('#start_time_hour').val(@_padZero(r.start_time.hour))
    @$('#start_time_minute').val(@_padZero(r.start_time.minute))
    @$('#end_time_hour').val(@_padZero(r.end_time.hour))
    @$('#end_time_minute').val(@_padZero(r.end_time.minute))

  _padZero: (n)->
    ('00' + n).slice(-2)

  _roundMinute: (minute)->
    Math.floor(minute / 5) * 5

  onTimeChanged: (e)->
    val = new DailyAvailableTimesEditor.Model.TimeRange(+@$('#start_time_hour').val(), +@$('#start_time_minute').val(),
      +@$('#end_time_hour').val(), +@$('#end_time_minute').val())
    @model.set('selected_time_range', val)

  onAddButtonClicked: (e)->
    e.preventDefault()
    @trigger 'clicked'
    @model.createDailyAvailableTime()

class DailyAvailableTimesEditor.View.ButtonsView extends Backbone.View
  el: '.buttons'
  events:
    'click .confirm': 'onConfirmButtonClicked'
    'click .cancel': 'onCancelButtonClicked'

  onConfirmButtonClicked: (e)->
    e.preventDefault()
    console.log 'Save!'
    @model.saveChanges()

  onCancelButtonClicked: (e)->
    e.preventDefault()
    console.log 'Cancel!'

class DailyAvailableTimesEditor.View.EmptyAvailableTimesChangesView extends Marionette.ItemView
  template: '#empty-available-times-changes-template'

class DailyAvailableTimesEditor.View.AvailableTimeCollectionView extends Marionette.CollectionView
  itemView: DailyAvailableTimesEditor.View.AvailableTimeView
  emptyView: DailyAvailableTimesEditor.View.EmptyAvailableTimesChangesView

  initialize: ->
    @on 'itemview:delete', @deleteItem, @

  deleteItem: (itemView)->
    console.log @collection.length
    available_time = itemView.model
    console.log available_time
    @collection.remove available_time
    @model.deleteDailyAvailableTime(available_time)
    console.log @collection.length

  itemAdded: (itemView)->
    console.log 'ItemAdded!!'

class DailyAvailableTimesEditor.View.AvailableTimesToAddView extends DailyAvailableTimesEditor.View.AvailableTimeCollectionView
  itemView: DailyAvailableTimesEditor.View.AvailableTimeToAddView

  onItemAdded: (itemView)->

  onItemRemoved: (itemView)->
    item = itemView.model
    item.destroy()

class DailyAvailableTimesEditor.View.AvailableTimesToDeleteView extends DailyAvailableTimesEditor.View.AvailableTimeCollectionView
  itemView: DailyAvailableTimesEditor.View.AvailableTimeToAddView

  deleteItem: (itemView)->
    console.log @collection.length
    available_time = itemView.model
    console.log available_time
    @collection.remove available_time
    @model.getAvailableTimesOfDay available_time.start_at, (err, coll)=>
      if err
        console.log err
      else
        coll.add(available_time)
    console.log @collection.length

  onItemRemoved: (itemView)->
    console.log 'nothing to do'

class DailyAvailableTimesEditor.View.ErrorMessagesView extends Marionette.ItemView
  template: '#error-messages-template'
  serializeData: ()->
    {items: @collection}
