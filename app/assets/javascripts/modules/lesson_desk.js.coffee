$ ->
  if $("#lesson-room .desk").length

    # 全体を管理する
    class DeskView extends Backbone.View

      events:
        'shown .switch_button': "onTabSwitched"

      initialize: ->
        @user_id = @$el.attr('data-user_id')
        user = new Backbone.Model(id: @user_id)
        @tab_views = [
          new TextbookTabView(el: @$('.textbook-pane'), model: user)
          new MaterialsTabView(el: @$('.materials-pane'), model: user)
          new DocumentCameraTabView(el: @$('.document-camera-pane'), model: user)
        ]

      onTabSwitched: (e)->
        console.log 'DeskView.onTabSwitched'
        view = @getActiveTabView()
        if view?
          view.onShow()

      onShow: (e)->
        console.log 'DeskView.onShow'
        @onTabSwitched(e)

      getActiveTabView: ->
        _.find @tab_views, (tab_view)=> tab_view.isActive()

    #
    #
    #
    class DeskTabView extends Backbone.View
      onShow: ->
        console.log "DeskTabView.onShow"
        if @content_view?
          @content_view.onShow()

      isActive: ->
        @$el.hasClass('active')

    #
    #
    #
    class TextbookTabView extends DeskTabView
      initialize: ->
        @content_view = new TextbookSelectView(el: @$(".textbook-select"))
        @listenTo @content_view, 'textbook:selected', @onTextbookSelected

      onTextbookSelected: (textbook_id)->
        @openTextbook(textbook_id)

      openTextbook: (textbook_id)->
        # テキスト表示内部での切替
        @$("a[data-target$='.textbook-view']").tab('show')
        textbook = new Textbook(id: textbook_id)
        @textbookView = new TextbookView(
          el: @$('.textbook-view')
          model: textbook
          studentId: @model.get('id')
        )
        @textbookView.on 'textbook:close', =>
          @$("a[data-target$='.textbook-select']").tab('show')
          @textbookView = null

    #
    #
    #
    class MaterialsTabView extends DeskTabView
      initialize: ->
        @content_view = new LessonMaterialsView(el: @$('.materials'))

    #
    #
    #
    class DocumentCameraTabView extends DeskTabView
      initialize: ->
        @content_view = new DocumentCameraView(el: @$('.document-camera'))

    #
    #
    #
    class Textbook extends Backbone.Model
      _answerBook: null

      select: ->
        @trigger("selected", this)

      # グローバルなテキストリソースのパスを返す。
      path: -> "/textbooks/#{@get('id')}.json"

      open: ->
        self = this
        $.get(@path())
          .success (data)->
            self.set(data)
          .error (err)->
            alert "Oops"

      answerBook: ->
        @_answerBook || @_answerBook = new AnswerBook @get('answer_book')

    #
    #
    #
    class AnswerBook extends Backbone.Model
      imagesPath: ->
        "/textbooks/#{@get('textbook_id')}/answer_book/images.json"
      url: ->
        "/textbooks/#{@get('textbook_id')}/answer_book/lesson_mode"

    #
    # テキストのリストから選択する
    #
    class TextbookSelectView extends Backbone.View
      events:
        "click .textbook": "textbookSelected"

      current: null

      initialize: ->

      textbookSelected: (e)->
        @current = $(e.currentTarget).attr("data-id")
        @trigger("textbook:selected", @current)

      onShow: ->
        console.log 'TextbookSelectView.onShow'

    #
    #
    #
    class TextbookView extends Backbone.View
      answerBookWindow: null

      events:
        "click .close": "close"
        "click .close_button": "close"
        "click .show-answer-book": "showAnswerBook"

      initialize: (options)->
        @studentId = options.studentId
        _.bindAll(this)
        @model.on("change:images_url", @render)
        @model.open()

      close: ->
        @trigger("textbook:close")

      render: ->
        # スライドをセットアップする
        template = _.template($("#templates .textbook").html())
        params =
          student_id: @studentId
          textbook_id: @model.get("id")
          url: @model.get("images_url")
          width: @model.get("view_width")
          height: @model.get("view_height")
        @$(".textbook-holder").empty().html(template(params))

      showAnswerBook: ->
        console.log "テキストの解答編を開こうとしています。"
        answer_book = @model.answerBook()
        if answer_book
          @answerBookWindow = window.open(answer_book.url(), 'answer_book', 'location=no,menubar=no,toolbar=no,personalbar=no,directories=no')

    #
    #
    #
    class LessonMaterialsView extends Backbone.View
      initialize: ->
        @slide_rendered = false

      onShow: ->
        console.log 'LessonMaterialsView.onShow'
        unless @_isSlideRendered()
          @_renderSlide()

      _isSlideRendered: ->
        @slide_rendered

      _renderSlide: ->
        html = @$('.lesson-materials-slide-template').html()
        @$el.empty().html(html)
        @slide_rendered = true
        console.log 'LessonMaterialsView._renderSlide'

    #
    #
    #
    class DocumentCameraView extends Backbone.View
      onShow: ->
        console.log 'DocumentCameraView.onShow'


    # Export
    window.DeskView = DeskView


    # 同時レッスンの時、生徒の切替時にデスクと映像を連動する
    $('.lesson-room-shared .desk-switch a').on('click', ->
      student_id = $(this).attr('data-student_id')
      $(".video[data-user_id='#{student_id}'] a").tab('show')
    )
