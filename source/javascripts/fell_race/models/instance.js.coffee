class FellRace.Models.Instance extends FellRace.Model
  savedAttributes: ["name","date","file","report","online_entry_opening",
    "online_entry_closing","online_entry","online_entry_fee","entry_limit",
    "time","pre_entry","postal_entry","postal_entry_fee","postal_entry_opening",
    "postal_entry_closing","postal_entry_address","eod","eod_fee"
  ]

  validation:
    date:
      required: true
    name:
      required: true

  initialize: (opts) ->
    super
    @build()

  build: =>
    unless @isNew()
      @buildDates()
      if @inFuture()
        @buildEntries()
      else
        @buildCheckpoints()
        @buildPerformances()
      @buildWinner()

  buildDates: =>
    for attribute in ["date", "postal_entry_opening", "postal_entry_closing", "online_entry_opening", "online_entry_closing"]
      if date = @get(attribute)
        @set attribute, Date.parse(date)
        @on "change:#{attribute}", @setEntryFlags
    @setEntryFlags()

  setEntryFlags: =>
    now = new Date
    @set "online_entry_active", @get('online_entry') and (@get("online_entry_opening") < now < @get("online_entry_closing"))
    @set "postal_entry_active", @get('postal_entry') and @get('entry_form') and (@get("postal_entry_opening") < now < @get("postal_entry_closing"))
    
  buildCheckpoints: =>
    @checkpoints = new FellRace.Collections.Checkpoints @get("checkpoints")
    @on "change:checkpoints", (model,data) =>
      @entries.reset data

  buildEntries: =>
    @entries = new FellRace.Collections.Entries @get("entries"), instance: @
    @on "change:entries", (model,data) =>
      @entries.reset data
    @entries.url = "#{@url()}/entries"
    @entries.on "add remove reset update_counts", () =>
      @setEntryCounts()

  setEntryCounts: =>
    total = @entries.length
    pending = @entries.pendingCount()
    @set
      total_count: total
      completed_count: total - pending
      pending_count: pending

  buildPerformances: =>
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @
    @on "change:performances", (model,data) =>
      @performances.reset data
    @performances.url = "#{@url()}/performances"

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
      unless (key is "file" and not @get("file_changed")) or (key is "entry_form" and not @get("entry_form_changed"))
        formdata.append("instance[#{key}]", value)
    formdata

  sync: (method, model, options) =>
    return super unless @get("file_changed")? or @get("entry_form_changed")?
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
    @set({file_changed: false, entry_form_changed: false}, {silent: true})
    @trigger "thaw"

  upload_error: (model, xhr, options) =>
    $.notify "error", "upload failed"

  getPerformancesCount: =>
    @get "performances_count"

  getDate: =>
    @get("date")

  inFuture: =>
    if date = @getDate()
      date > Date.now()

  inPast: =>
    if date = @getDate()
      date < Date.now()
