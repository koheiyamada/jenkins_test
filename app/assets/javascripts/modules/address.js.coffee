$ ->

  $("form .address").each ->
    $address = $(this)
    # 住所検索
    $searchButton = $("button", $address)
    $searchButton.click ->
      postal_code1 = $(".postal_code1", $address).val()
      postal_code2 = $(".postal_code2", $address).val()
      postal_code = "#{postal_code1}-#{postal_code2}"
      $.getJSON("/addresses/#{postal_code}", (data)->
        $(".state", $address).val(data.prefecture).trigger('change')
        $(".line1", $address).val(data.line1).trigger('change')
      )
    # フォーマットチェック
    $("input.postal_code").bind "keyup", (e)->
      $searchButton.attr("disabled", $(this).val().match(/^\d+-\d+$/) == null)