$ ->
  $(".lesson-calendar-holder").each ->
    $holder = $(this)
    path = $holder.attr("data-path")
    $holder.load(path, (data, status)->
      #alert "Loaded?"
    )
    $holder.on("click", ".ec-calendar-header .ec-month-nav a", (e)->
      e.preventDefault()
      $holder.load($(this).attr("href"))
    )
