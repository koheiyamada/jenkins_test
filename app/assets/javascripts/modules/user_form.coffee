$ ->
  if $('#user_operating_system_operating_system_id').length
    $os_select_field = $('#user_operating_system_operating_system_id')
    updateCustomOsNameField = ->
      custom_os_name_required = $('option:selected', $os_select_field).attr('data-custom_os_name_required')
      $('#user_operating_system_custom_os_name').attr('disabled', custom_os_name_required == 'false')
    $os_select_field.on('change', -> updateCustomOsNameField())
    updateCustomOsNameField()
