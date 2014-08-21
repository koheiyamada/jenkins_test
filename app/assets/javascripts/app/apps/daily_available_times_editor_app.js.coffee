class AID.App.DailyAvailableTimesEditorApp extends Marionette.Application
  run: ->
    @addRegions
      available_times_of_day_region: '#available_time_of_day-region'
      error_messages_region: '.error-messages'

    @addInitializer (options)->
      $editor = $('.daily-available-times-editor')
      minimum_time_range = +$editor.attr('data-minimum_time_range')
      DailyAvailableTimesEditor.Model.DailyAvailableTime.prototype.urlRoot = '/tu/daily_available_times'
      editor        = new DailyAvailableTimesEditor.Model.Editor(minimum_time_range: minimum_time_range)
      date_selector = new DailyAvailableTimesEditor.View.DateSelectorView(model: editor)
      time_selector = new DailyAvailableTimesEditor.View.TimeSelectorView(model: editor)
      buttons_view  = new DailyAvailableTimesEditor.View.ButtonsView(model: editor)

      adds_view = new DailyAvailableTimesEditor.View.AvailableTimesToAddView
        collection: editor.available_times_to_add
        model: editor
        el: $('.daily-available-times-editor .add')
      deletes_view = new DailyAvailableTimesEditor.View.AvailableTimesToDeleteView
        collection: editor.available_times_to_delete
        model: editor
        el: $('.daily-available-times-editor .delete')

      @listenTo editor, 'date:selected', (date, available_times)->
        view = new DailyAvailableTimesEditor.View.AvailableTimesOfDayView(collection: available_times, model: editor, date: date)
        @available_times_of_day_region.show(view)

      @listenTo editor, 'validation:error', (error_codes)->
        error_messages = _.map error_codes, (code)=> $("#error-message-#{code}").text()
        view = new DailyAvailableTimesEditor.View.ErrorMessagesView(collection: error_messages)
        @error_messages_region.show(view)

      @listenTo time_selector, 'clicked', =>
        @error_messages_region.close()

      now = new Date()
      console.log now
      date_selector.selectDate(new Date(now.getFullYear(), now.getMonth(), now.getDate()))
      adds_view.render()
      deletes_view.render()

      $(window).on 'beforeunload', (e)=>
        if editor.hasChanges()
          AID.getMessage('message-leaving-without-saving-changes')

    @start()
