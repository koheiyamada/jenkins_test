$ ->
  if $(".new_unavailable_day > .date_picker").length
    $(".new_unavailable_day > .date_picker").datepicker(
      onSelect: (dateText, picker)->
        $("#date").val(dateText)
        $("form.new_unavailable_day").submit()
        false
      dateFormat: "yy-mm-dd"
      minDate: new Date()
    )
