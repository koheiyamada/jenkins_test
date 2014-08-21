$ ->
  $(".new_tutor_app_form, .edit_tutor_app_form").each ->
    $form = $(this)

    $("input[name='tutor_app_form[special_tutor]']").on("change", ->
      $("#tutor_app_form_special_tutor_wage").attr("disabled", this.value == 'false')
    )

    $("#tutor_app_form_special_tutor_wage").attr("disabled", !this.checked)

    # PCの性能入力
    $os_select = $("#tutor_app_form_os_id", $form)
    render = ->
      flag = $('option:selected', $os_select).attr("data-windows_experience_index_score_available")
      $('#tutor_app_form_windows_experience_index_score').attr("disabled", flag == "false")
      custom_os_name_required = $('option:selected', $os_select).attr("data-custom_os_name_required")
      $('#tutor_app_form_custom_os_name').attr("disabled", custom_os_name_required == "false")

    $os_select.on("change", -> render())
    render()

    # 面談日程選択の時間を制限する
    limitHour = ($select, from, to)->
      $select.find('option').each ->
        $option = $(@)
        hour = +$option.val()
        if hour < from || hour > to
          $option.remove()

    limitHour($('#tutor_app_form_interview_datetime_1_4i'), 10, 21)
    limitHour($('#tutor_app_form_interview_datetime_2_4i'), 10, 21)
    limitHour($('#tutor_app_form_interview_datetime_3_4i'), 10, 21)
