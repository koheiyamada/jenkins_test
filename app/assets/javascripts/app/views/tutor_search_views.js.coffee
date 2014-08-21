# 学年選択フィールド
class TutorSearch.View.GradeFieldView extends Backbone.View
  events:
    'change': 'onChanged'

  initialize: ->
    # 科目フィールドとレベルフィールドを既存の値で初期化する（クリアはしない）
    @subjectFieldView = new TutorSearch.View.SubjectFieldView(el: $('#subject_id'))

  onChanged: ->
    # 科目選択フィールドを初期化する
    @subjectFieldView = new TutorSearch.View.SubjectFieldView(el: $('#subject_id'))
    @subjectFieldView.updateSubjectList(@getSelectedId())

  getSelectedName: ->
    @$('option:selected').text()

  getSelectedId: ->
    @$('option:selected').val()

# 指導科目選択フィールド
class TutorSearch.View.SubjectFieldView extends Backbone.View
  events:
    'change': 'onChanged'

  onChanged: ->
    @initLevelView()
    @levelFieldView.updateLevelList(@getSelectedId())

  getSelectedName: ->
    @$('option:selected').text()

  getSelectedId: ->
    @$('option:selected').val()

  updateSubjectList: (gradeId)->
    if gradeId
      @collection = new TutorSearch.Collection.SubjectCollection(gradeId: gradeId)
      @collection.fetch
        success: =>
          @render()
          @initLevelView()
    else
      @render()
      @initLevelView()

  # 難易度フィルドを初期化（クリア）する
  initLevelView: ->
    @levelFieldView = new TutorSearch.View.LevelFieldView(el: $('#level'))
    @levelFieldView.render()

  render: ->
    template = _.template '<option value="{{id}}">{{name}}</option>'
    @$el.empty()
    @$el.append template(id: null, name: '-')
    if @collection
      @collection.each (subject)=>
        @$el.append template(subject.attributes)

class TutorSearch.View.LevelFieldView extends Backbone.View
  updateLevelList: (subjectId)->
    if subjectId
      @collection = new TutorSearch.Collection.LevelCollection(subjectId: subjectId)
      @collection.fetch
        success: =>
          @render()

  render: ->
    template = _.template '<option value="{{level}}">{{name}}</option>'
    @$el.empty()
    @$el.append template(level: null, name: '-')
    if @collection
      @collection.each (level)=>
        if level.get('level') > 0
          @$el.append template(level.attributes)


class TutorSearch.View.WeekdayScheduleField extends Backbone.View
  events:
    'change input[name^="wdays"]': 'onWdayChanged'

  initialize: ->
    @enableTimeFields(@isWdaySelected())

  isWdaySelected: ->
    @getSelectedCount() > 0

  getSelectedWday: ->
    @$('input[name="wday"]:checked').val()

  getSelectedCount: ->
    @$('input[name^="wdays"]:checked').length

  onWdayChanged: ->
    n = @getSelectedCount()
    console.log "#{n} wdays are selected"
    @enableTimeFields(n > 0)

  enableTimeFields: (flag)->
    if !flag
      @clearTimeFields()
    @$('select').attr('disabled', !flag)

  clearTimeFields: ->
    @$('select[name^=start_time]').each ->
      this.selectedIndex = 0
    @$('select[name^=end_time]').each ->
      this.selectedIndex = 0

# チューター検索における日付選択用
# チューターのオプション可能時間表示用のビューとは動作が異なり、
# 複数日を選択できる。
class TutorSearch.View.DateSelectorView extends Backbone.View
  el: '.date-select'

  initialize: (options)->
    today = new Date()
    defaultDate = @_defaultDate()
    @$('.date_picker').datepicker
      onSelect: (dateText, picker)=>
        @selectDate(new Date(dateText))
        false
      dateFormat: 'yy/mm/dd'
      minDate: today
      defaultDate: defaultDate
    @_initDates()

  _initDates: ->
    attr = @$el.attr('data-dates')
    if attr? && attr.length
      dateTexts = attr.split(',')
      _.each dateTexts, (dateText)=>
        @selectDate(new Date(dateText))

  _defaultDate: ->
    s = @$('#selected_date').val()
    if s
      new Date(s)
    else
      new Date()

  selectDate: (selected_date)->
    @$('#selected_date').val(selected_date.toString())
    date = TutorSearch.Model.SelectedDate.fromDate(selected_date)
    console.log date
    d = @collection.find (elm)->
      console.log elm
      console.log date
      elm.id == date.id
    if d?
      @collection.remove d
      console.log "Removed #{date.toDateString()}"
    else
      @collection.add date
      console.log "Added #{date.toDateString()}"


class TutorSearch.View.SelectedDateView extends Marionette.ItemView
  template: '#selected-date-template'
  className: 'selected-date'

  events:
    'click .delete-button': 'onDeleteButtonClicked'

  onDeleteButtonClicked: (e)->
    @model.collection.remove(@model)

  onRender: ->
    @$('input').val(@model.toDateString())


class TutorSearch.View.SelectedDatesView extends Marionette.CollectionView
  itemView: TutorSearch.View.SelectedDateView

  itemAdded: (itemView)->
    console.log 'haha'

  clear: ->
    @collection.reset([])

class TutorSearch.View.AndOrView extends Backbone.View
  initialize: ->
    @listenTo @collection, 'add', @onSelectedDatesChanged

  onSelectedDatesChanged: ->
    if @collection.length > 1
      if @$(':radio:checked').length
        console.log 'already seledted'
      else
        @$('#and_or_or').click()

class TutorSearch.View.SearchView extends Backbone.View
  events:
    'click a[href="#clear"]': 'onClearButtonClicked'
    'click #tutor_type_beginner': 'onBeginnerTutorSelected'
    'click #undertake_group_lesson': 'onGroupLessonClicked'

  initialize: ->
    @grade_field          = new TutorSearch.View.GradeFieldView(el: @$('#grade'))
    @weekday_scheduled_field = new TutorSearch.View.WeekdayScheduleField(el: @$('.weekday_schedule'))
    selected_dates = new Backbone.Collection()
    @selected_dates_view = new TutorSearch.View.SelectedDatesView(collection: selected_dates, el: $('.selected-dates'))
    @date_selector_view  = new TutorSearch.View.DateSelectorView(collection: selected_dates)
    @and_or_view         = new TutorSearch.View.AndOrView(collection: selected_dates, el: $('.and_or'))

  onClearButtonClicked: (e)->
    e.preventDefault()
    @clearFields()

  clearFields: ->
    @$('input').attr('checked', false)
    @$('input[type="text"]').val('')
    @$('option').attr('selected', false)
    @$('input[type="number"]').val('')
    @weekday_scheduled_field.enableTimeFields(false)
    @selected_dates_view.clear()

  onBeginnerTutorSelected: (e)->
    @$('#undertake_group_lesson').attr('checked', false)

  onGroupLessonClicked: (e)->
    @$('#tutor_type_beginner').attr('checked', false)
