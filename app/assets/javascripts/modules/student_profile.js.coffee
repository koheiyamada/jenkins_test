$ ->

  if $("form.edit_student,form.new_student").length
    $form = $("form.edit_student,form.new_student")

    requiredFieldsFilled = ->
      $(":text[name='student[nickname]']").val().match(/.+/) &&
      $(":text[name='student[first_name]']").val().match(/.+/) &&
      $(":text[name='student[last_name]']").val().match(/.+/) &&
      $(":text[name='student[user_name]']").val().match(/.+/)

    updateSubmitButton = ->
      $(":submit", $form).attr("disabled", !requiredFieldsFilled())

    $form.bind "keyup", (e)-> updateSubmitButton()
    updateSubmitButton()
