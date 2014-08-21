$ ->

  if $('.new_weekday_schedule_holder').length
    $holder = $('.new_weekday_schedule_holder')
    $holder.load $holder.attr('data-form_path')