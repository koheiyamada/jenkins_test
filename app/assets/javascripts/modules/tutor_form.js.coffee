$ ->
  $form = $('form.new_tutor, form.edit_tutor')
  if $form.length
    $special_tutor_checkbox = $('input#special_tutor', $form)
    $regular_tutor_checkbox = $('input#regular', $form)

    checkRegularIfSpecialTutor = ->
      if $special_tutor_checkbox.is(':checked')
        $regular_tutor_checkbox.attr('checked', true)

    $special_tutor_checkbox.on 'change', (e)-> checkRegularIfSpecialTutor()

    $regular_tutor_checkbox.on 'change', (e)->
      unless $regular_tutor_checkbox.is(':checked')
        $special_tutor_checkbox.attr('checked', false)

    checkRegularIfSpecialTutor()
