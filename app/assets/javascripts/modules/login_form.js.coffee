$ ->
  if $('.login_form').length
    $form = $('.login_form form')
    $user_name_field = $('#user_user_name')
    $user_name_field.focus()
    $form.find('.actions input').on 'click', (e)->
      e.preventDefault()
      text = $user_name_field.val()
      new_text = text.replace(/[　\s]+/g, '') # 全角スペース、半角スペース、タブを削除する
      $user_name_field.val(new_text)
      $form.submit()
