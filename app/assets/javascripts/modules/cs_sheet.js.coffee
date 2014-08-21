$ ->
  $(".new_cs_sheet").each ->
    $form = $(this)
    $("input[name='cs_sheet[score]']").bind "change", (e)->
      $(".reasons", $form).toggle(parseInt($(this).val()) <= 2)
