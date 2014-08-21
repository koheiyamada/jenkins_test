$ ->
  if $('.new_parent_registration_form').length
    $form = $('.new_parent_registration_form')
    $os_select = $("#parent_registration_form_os_id", $form)

    render = ->
      flag = $('option:selected', $os_select).attr("data-windows_experience_index_score_available")
      $('#parent_registration_form_windows_experience_index_score').attr("disabled", flag == "false")

    $os_select.on("change", -> render())

    render()
