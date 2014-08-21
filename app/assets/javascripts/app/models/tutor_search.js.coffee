class TutorSearch.Model.Grade extends Backbone.Model

class TutorSearch.Model.Subject extends Backbone.Model

class TutorSearch.Model.Level extends Backbone.Model

class TutorSearch.Collection.SubjectCollection extends Backbone.Collection
  model: TutorSearch.Model.Subject
  url: -> "/grades/#{@gradeId}/subjects"
  initialize: (options)->
    @gradeId = options.gradeId

class TutorSearch.Collection.LevelCollection extends Backbone.Collection
  model: TutorSearch.Model.Level
  url: -> "/subjects/#{@subjectId}/levels"
  initialize: (options)->
    @subjectId = options.subjectId


class TutorSearch.Model.WeekdaySchedule
  wday: null
  startTime: null
  endTime: null

  initialize: (wday, startTime, endTime)->
    @wday = wday
    @startTime = startTime
    @endTime = endTime


class TutorSearch.Model.SelectedDate extends Backbone.Model
  year: null
  month: null
  date: null

  fromDate: (date)->
    new TutorSearch.SelectedDate(year: date.getFullYear(), month: date.getMonth() + 1, date: date.getDate())

  initialize: ->
    @set('id', @toDateString())

  toDateString: ->
    y = @get('year')
    m = AID.padZero(@get('month'))
    d = AID.padZero(@get('date'))
    "#{y}-#{m}-#{d}"

TutorSearch.Model.SelectedDate.fromDate = (date)->
  new TutorSearch.Model.SelectedDate(year: date.getFullYear(), month: date.getMonth() + 1, date: date.getDate())
