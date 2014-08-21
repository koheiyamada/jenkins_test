$ ->
  if $("#new_exam").length
    $fileForm = $("#new_exam input[type=file]")
    updateButtonState = (fileForm)->
      $("#new_exam button").attr("disabled", if fileForm.val() then false else true)
    $fileForm.change ->
      updateButtonState($(this))
    updateButtonState($fileForm)
