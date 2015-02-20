class FellRace.Models.Instance extends FellRace.Model

  initialize: (opts) ->
    super
    @build()

  build: =>
    @entries = new FellRace.Collections.Entries(@get("entries"),instance:@)
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @

    @entries.on "add remove reset", () =>
      @set total_entries: @entries.length

    _.each ["performances","entries"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

    @buildWinner()

  setUrls: =>
    url_stem = @url
    @entries.url = "#{url_stem}/entries"
    @performances.url = "#{url_stem}/performances"

  buildWinner: =>
    @winner = new FellRace.Models.Competitor(@get("winner"))
    @on "change:winner", (model,winner) =>
      @winner.clear()
      @winner.set winner

  filename: () =>
    @get('file')?.name

  validate: (attrs, options) =>
    # return "Please choose a file" unless attrs.file? or attrs.url?
    # return "Please give a label" if !attrs.name or !attrs.name.length or attrs.name == ""
    undefined

  formdata: () =>
    formdata = new FormData()
    _.each _.pick(@attributes, @synced), (value, key, list) =>
      formdata.append("instance[#{key}]", value)
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

  upload_progress: (e) =>
    if e and e.lengthComputable
      percentage = parseInt(e.loaded / e.total * 100, 10)
      $.notify "progress", percentage

  upload_end: () =>
    $.notify "finish:progress"
    @set({file: null,performances_count: "processing"}, quiet:true)
    @trigger "thaw"

  upload_error: (model, xhr, options) =>
    $.notify "error", "upload failed for #{@filename}"

  resultsUrl: =>
    "/#{@get("race_slug")}/#{@get("name")}"

  getPerformancesCount: =>
    @get "performances_count"

  onSetDate: (val, opts) =>
    date = val.split "-"
    data =
      day: date[2]
      month: date[1]
      year: date[0]
      name: date[0]
    unless @get("entry_closing") and Date.parse(@get("entry_closing")) < Date.parse(@get("date"))
      data["entry_closing"] = new Date(val)
    @set data,
      opts

  getDate: =>
    if date = @get("date")
      Date.parse(date)

  inFuture: =>
    if date = @getDate()
      date > Date.now()

  inPast: =>
    if date = @getDate()
      date < Date.now()

  