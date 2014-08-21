$ ->
  $(".imgbtnovr").each ->
    $holder = $(this)
    imgpath = $holder.attr('src')
    i = imgpath.lastIndexOf("/")
    if $holder.attr('over')
      if i>0
        imgpath = imgpath.substring(0,i+1)
        $holder.attr('over',imgpath + $holder.attr('over'))
      $holder.hover(
        ->
          a = $(this).attr('over')
          b = $(this).attr('src')
          $(this).attr('src',a)
          $(this).attr('over',b)
        ->
          a = $(this).attr('over')
          b = $(this).attr('src')
          $(this).attr('src',a)
          $(this).attr('over',b)
      )