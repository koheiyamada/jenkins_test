$ ->
  $('.lesson_report-search').each ->
    $form = $(this)
    $("input[name='date']", $form).datepicker(
      dateFormat: "yy-mm-dd"
      maxDate: new Date()
    )

  $('.group_lesson-search').each ->
    $form = $(this)
    $("input[name='date']", $form).datepicker(
      dateFormat: "yy-mm-dd"
    )
