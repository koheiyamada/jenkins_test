class AID.App.MessageFormView extends Backbone.View
  events:
    'click .add-file': 'onAddFileClicked'
    'click .buttons > input': 'onSendClicked'
    'change input:file': 'onFileChanged'

  max_files_count: 3
  max_file_size: 20000000

  initialize: ->
    @send_button_disabled = false
    @$files_field = @$('.message-files')
    unless _.isEmpty @$files_field.attr('data-max_count')
      @max_files_count = +@$files_field.attr('data-max_count')
    unless _.isEmpty @$files_field.attr('data-max_file_size')
      @max_file_size = +@$files_field.attr('data-max_file_size')

  onAddFileClicked: (e)->
    e.preventDefault()
    console.log 'clicked'

  onFileChanged: (e)->
    console.log 'changed'
    $field = $(e.currentTarget)
    if $field.val().length
      errors = @_validateFile($field[0])
      if errors.length == 0
        @_addSelectedFileView($field)
        @_addFileField()
        @render()
      else
        AID.resetFileField($field)
        error_messages = _.map errors, (err)=>
          AID.getMessage("error-message-#{err}")
        alert error_messages.join("\n")

  _validateFile: (file_field)->
    errors = []
    if file_field.files
      file = file_field.files[0]
      if file
        if file.size > @max_file_size
          errors.push 'file_too_large'
    errors

  _addSelectedFileView: ($field)->
    view = new AID.App.SelectedMessageFileView($field: $field, parent: @)
    @$('.selected-files').append(view.render().el)

  _addFileField: ->
    view = new AID.App.MessageFileFieldView()
    @$('.file-field').append(view.render().el)

  render: ->
    @$('.send').attr('disabled', @send_button_disabled)
    @$('.file-field').toggle(!@noMoreFiles())

  noMoreFiles: ->
    fields = @fileFields()
    fields.length >= @max_files_count

  _disableSendButton: (flag)->
    @send_button_disabled = flag
    @render()

  onSendClicked: (e)->
    e.preventDefault()
    unless @send_button_disabled
      path = @$el.attr('action')
      data = @$el.serialize()
      @_disableSendButton(true)
      req = $.post(path + '.json', data)
      req.done (res)=>
        console.log res
        @_uploadFiles res.id,
          done: (errors)=>
            if errors && errors.length > 0
              alert AID.getMessage("error-message-file_upload_error")
            location.href = path
      req.fail (res)=>
        if res.status == 422
          AID.showErrorMessages(res.responseJSON.error_messages)
          console.log res.responseJSON
      req.always (res)=>
        @_disableSendButton(false)
      console.log 'Send!'

  _uploadFiles: (id, options={})->
    fields = @fileFields()
    console.log "#{fields.length} fields are filled."
    if fields.length
      finished_count = 0
      errors = []
      uploader = @$el.fileupload
        url: "/my_messages/#{id}/files"
        dataType: 'json'
        sequentialUploads: true
        fail: (e, data)=>
          errors.push(e: e, data: data)
        progressall: (e, data)->
          progress = parseInt(data.loaded / data.total * 100, 10);
          $('#file-upload-progress .bar').css('width', progress + '%')
        always: (e, data)->
          finished_count += 1
          console.log "#{finished_count} files processed"
          if finished_count >= fields.length
            options.done(errors) if options.done
      uploader.fileupload 'add', fileInput: fields
    else
      options.done() if options.done

  fileFields: ->
    @$('input:file').filter (i, field)=>
      field.value.length > 0

  hasFiles: ->
    _.some @fileFields, (field)=>
      field.value.length > 0

class AID.App.MessageFileFieldView extends Backbone.View
  className: 'field'
  template: '<input id="user_files_" name="user_files[]" type="file">'
  render: ->
    @$el.html(@template)
    @

class AID.App.SelectedMessageFileView extends Backbone.View
  tagName: 'span'
  className: 'selected-message-file'
  template: '<span>{{filename}}</span><span class="delete-button">&times;</span>'

  events:
    'click .delete-button': 'onDeleteButtonClicked'

  initialize: (options)->
    @$field = options.$field
    @filename = _.last(@$field.val().split(/[\/\\]/))
    @parent = options.parent

  render: ->
    html = _.template(@template, filename: @filename)
    @$el.html(html)
    @

  onDeleteButtonClicked: (e)->
    console.log 'delete!'
    @$field.remove()
    @$el.remove()
    if @parent
      @parent.render()
