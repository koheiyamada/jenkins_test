$ ->
  if $('form.teaching_subjects').length
    $form = $('form.teaching_subjects')
    $('.select-all', $form).on 'click', (e)->
      $(this).parent().find('input[type="checkbox"]').prop('checked', true)
    $('.unselect-all', $form).on 'click', (e)->
      $(this).parent().find('input[type="checkbox"]').prop('checked', false)
