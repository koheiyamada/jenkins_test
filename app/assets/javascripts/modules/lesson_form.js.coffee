$ ->

  $("form.edit_basic_lesson, form.edit_lesson").each ->
    $form = $(this)
    $dateField = $("input[name='date']")
    $date_picker = $('.date_picker', $form)
    date_string = $date_picker.attr('data-max_date')
    max_date = if date_string then new Date(date_string) else '+3m'

    $date_picker.datepicker(
      onSelect: (dateText, picker)->
        $dateField.val(dateText)
        false
      minDate: new Date()
      maxDate: max_date
      dateFormat: "yy-mm-dd"
      defaultDate: $dateField.val()
    )

    $("input[name='date2']").datepicker()
