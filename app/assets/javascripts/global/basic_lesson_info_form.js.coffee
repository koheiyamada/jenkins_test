$ ->
  if $("#basic_lesson_info_time_form").length
    showScheduleForms = (n)->
      $("#basic_lesson_info_time_form .schedule-form").hide()
      $("#basic_lesson_info_time_form .schedule-form[data-index='#{i}']").show() for i in [0 .. (n-1)]

    $("#basic_lesson_info_time_form input[type='radio']").click ->
      n = parseInt(this.value)
      showScheduleForms(n)

    showScheduleForms(1)
