$ ->
  if $('.tutor-monthly-income').length

    class TutorMonthlyIncome extends Backbone.Model

    class RefreshButtonView extends Backbone.View
      events:
        'click .refresh-button': 'refresh'

      initialize: (options)->
        _.bindAll(this)
        @model.on 'change:updated_at', @onUpdated

      refresh: ->
        $.post('income_of_this_month/calculate')
          .done (data)=>
            AID.startWaiting(=> @updateMonthlyIncome())
          .fail (res)->
            AID.showErrorMessages(['ERROR'])

      updateMonthlyIncome: ->
        $.get('income_of_this_month.json')
          .done (data)=>
            @model.set(data)
          .fail (res)=>
            AID.showErrorMessages(['ERROR'])

      onUpdated: ->
        location.reload()

    $.getJSON('income_of_this_month.json')
      .done (data)->
        tutor_monthly_income = new TutorMonthlyIncome(data)
        refresh_button_view  = new RefreshButtonView(model: tutor_monthly_income, el: $('.buttons'))
