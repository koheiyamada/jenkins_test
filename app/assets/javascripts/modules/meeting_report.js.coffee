$ ->
  $('.new_meeting_report, .edit_meeting_report').each ->
    $form = $(@)
    $('textarea', $form).autosize()
