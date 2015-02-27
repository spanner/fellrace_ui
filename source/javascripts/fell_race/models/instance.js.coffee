class FellRace.Models.Instance extends FellRace.Model
  savedAttributes: ["name","date","file","report","online_entry_opening",
    "online_entry_closing","online_entry","online_entry_fee","entry_limit",
    "time","pre_entry","postal_entry","postal_entry_fee","postal_entry_opening",
    "postal_entry_closing","eod","eod_fee"
  ]

  toJSON: =>
    json = super
    delete json.instance["file"] unless @get("file_changed")?
    json

  initialize: (opts) ->
    super
    @build()

  build: =>
    @entries = new FellRace.Collections.Entries @get("entries"), instance: @
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @
    @setUrls()

    @entries.on "add remove reset", () =>
      @set total_entries: @entries.length

    _.each ["performances","entries"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

    @buildWinner()

  setUrls: =>
    url_stem = @url()
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
    _.each @attributes, (value, key, list) =>
      formdata.append("instance[#{key}]", value)
    formdata

  sync: (method, model, options) =>
    return super unless @get("file_changed")?
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

  getPerformancesCount: =>
    @get "performances_count"

  getDate: =>
    if date = @get("date")
      Date.parse(date)

  inFuture: =>
    if date = @getDate()
      date > Date.now()

  inPast: =>
    if date = @getDate()
      date < Date.now()

  onlineEntryReady: =>
    #TODO !!
  