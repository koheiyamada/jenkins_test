class AID.App.OptionalLessonScheduleFormApp extends Marionette.Application
  run: ->
    @addRegions
      available_times_of_day_region: '#available_time_of_day-region'

    @addInitializer (options)->
      tutor_id = $('.optional-lesson-schedule-form').attr('data-tutor_id')
      date_selector = new App.View.TutorScheduleDateSelectorView(tutor_id: tutor_id)
      daily_available_times = new App.Model.DailyAvailableTimesCache(tutor_id: tutor_id)

      @listenTo date_selector, 'selected', (date)->
        daily_available_times.getAvailableTimesOfDay date, (err, available_times)=>
          view = new App.View.AvailableTimesOfDayView(collection: available_times, model: daily_available_times, date: date)
          @available_times_of_day_region.show(view)

      now = new Date()
      console.log now
      date_selector.selectDate(new Date(now.getFullYear(), now.getMonth(), now.getDate()))

    @start()
