class AID.App.TutorSearchApp extends Marionette.Application
  run: ->

    @addInitializer (options)->
      search = new TutorSearch.View.SearchView(el: $('.tutor-search'))
    @start()
