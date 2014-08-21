App =
  Util: {}
  Validation: {}
  View: {}
  Model: {}
  Collection: {}
  Template: {}
  Inits: {}

window.App = App

apps = [
  'TutorSearch'
  'OptionalLessonScheduleForm'
  'DailyAvailableTimesEditor'
  'MonthlyChargingUsersCalculation'
  'UserSearchView'
]

for app in apps
  obj =
    View: {}
    Model: {}
    Collection: {}
    Util: {}
  window[app] = obj
