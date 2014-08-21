$ ->

  if $("form.edit_parent,form.new_parent").length
    $form = $("form.edit_parent,form.new_parent")

    requiredFieldsFilled = ->
      $(":text[name='parent[first_name]']").val().match(/.+/) &&
      $(":text[name='parent[last_name]']").val().match(/.+/) &&
      $(":text[name='parent[user_name]']").val().match(/.+/)

    updateSubmitButton = ->
      $(":submit", $form).attr("disabled", !requiredFieldsFilled())

    $form.bind "keyup", (e)-> updateSubmitButton()
    updateSubmitButton()
