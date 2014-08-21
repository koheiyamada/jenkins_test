$ ->
  #$.cookie.defaults.path = '/'

  if $('.tutor-daily-available-times-widget').length
    new AID.App.TutorDailyAvailableTimesWidget().run()

  if $('.tutor-search').length
    new AID.App.TutorSearchApp().run()

  if $('.optional-lesson-schedule-form').length
    new AID.App.OptionalLessonScheduleFormApp().run()

  if $('.daily-available-times-editor').length
    new AID.App.DailyAvailableTimesEditorApp().run()

  if $('.monthly-charging-users-calculation').length
    new AID.App.MonthlyChargingUsersCalculation($('.monthly-charging-users-calculation')).run()

  if $('.user-search').length
    new AID.App.UserSearchView(el: $('.user-search'))

  if $('#new_message').length
    new AID.App.MessageFormView(el: $('#new_message'))
