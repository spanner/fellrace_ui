class FellRace.Models.Attachment extends Backbone.Model
  defaults:
    name: null
    file: null
    extension: ""
    url: null
  # unsynced: ['url']

  initialize: () =>
    @wait_then_save = _.debounce @save, 500
    if url = @get('url')
      @set "extension", url.split('.').pop()
    @on "change:file", (e) =>
      if @get('file')?
        @set "extension", @filename().split('.').pop()
        @set "name", @filename().split(/[\/\\]/).pop()
    @on "change:name", () =>
      @wait_then_save()

  autosave: () =>
    @save()
  
  filename: () =>
    @get('file')?.name

  validate: (attrs, options) =>
    return "Please choose a file" unless attrs.file? or attrs.url?
    return "Please give a file name" if !attrs.name or !attrs.name.length
    undefined

  formdata: () =>
    formdata = new FormData()
    _.each _.omit(@attributes, @unsynced), (value, key, list) =>
      formdata.append("attachment[#{key}]", value)
    formdata

  sync: (method, model, options) =>
    # can we rely on @changed(file)?
    return super unless @get('file')? and (method is "create" or method is "update")
    options.data = @formdata()
    options.contentType = false
    options.processData = false
    options.xhr = () =>
      xhr = $.ajaxSettings.xhr()
      xhr.upload.onloadstart = @upload_begin
      xhr.upload.onprogress = @upload_progress
      xhr.upload.onloadend = @upload_end
      xhr.upload.onerror = @upload_error
      xhr
    super(method, model, options)

  upload_begin: () =>
    @trigger "freeze"
    $.notify "start:progress", "Uploading #{@filename()}"
    @set "editable", false

  upload_progress: (e) =>
    if e and e.lengthComputable
      percentage = parseInt(e.loaded / e.total * 100, 10)
      $.notify "progress", percentage

  upload_end: () =>
    $.notify "finish:progress"
    @set 'file', null
    @set "editable", true
    @trigger "thaw"

  upload_error: (model, xhr, options) =>
    $.notify "error", "upload failed for #{@filename}"