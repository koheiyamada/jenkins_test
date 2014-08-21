$ ->
  $(".new_bs_app_form").each ->
    $form = $(this)
    # PCの性能入力
    $os_select = $("#bs_app_form_os_id", $form)
    render = ->
      flag = $('option:selected', $os_select).attr("data-windows_experience_index_score_available")
      $('#bs_app_form_windows_experience_index_score').attr("disabled", flag == "false")
      custom_os_name_required = $('option:selected', $os_select).attr("data-custom_os_name_required")
      $('#bs_app_form_custom_os_name').attr("disabled", custom_os_name_required == "false")
    $os_select.on("change", -> render())
    render()
