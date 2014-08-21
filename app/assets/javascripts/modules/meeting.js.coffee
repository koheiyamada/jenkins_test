$ ->
  $('.new_meeting_schedule,.edit_meeting_schedule').each ->
    $form = $(@)
    $dateField = $("input[name='date']")
    $(".date_picker", $form).datepicker(
      onSelect: (dateText, picker)->
        $dateField.val(dateText)
        false
      minDate: new Date()
      maxDate: "+3m"
      dateFormat: "yy-mm-dd"
      defaultDate: $dateField.val()
    )

  $('.meeting-member-list .student-list').tooltip()
