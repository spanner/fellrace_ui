class FellRace.Models.Instance extends FellRace.Model
  singular_name: 'instance'
  savedAttributes: [
    "name","date","report","online_entry_opening",
    "online_entry_closing","online_entry","online_entry_fee","entry_limit",
    "time","pre_entry","postal_entry","postal_entry_fee","postal_entry_opening",
    "postal_entry_closing","postal_entry_address","eod","eod_fee","excluded",
    "category_names"
  ]

  defaults: 
    entry_data: {}
    club_entry_data: {}
    cat_data: {}

  validation:
    date:
      required: true
    name:
      required: true

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
      @checkpoints.reset data

  buildEntries: =>
    @entries = new FellRace.Collections.Entries [],
      instance: @
      url: "#{@url()}/entries"
    @entries.on "add remove reset update_counts", @setEntryCounts
    @entries.on "model:change:cancelled", @moveEntry

    @cancelled_entries = new FellRace.Collections.Entries [],
      instance: @
      url: "#{@url()}/entries"
    @cancelled_entries.on "model:change:cancelled", @moveEntry

    @partitionEntries() if @get("entries")
    @on "change:entries", @partitionEntries

  partitionEntries: =>
    [cancelled_entries, entries] = _.partition(@get("entries"), (e) -> e.cancelled)
    @entries.reset entries
    @cancelled_entries.reset cancelled_entries

  moveEntry: (model,cancelled) =>
    if cancelled
      @entries.remove model
      @cancelled_entries.add(model)
    else
      @cancelled_entries.remove model
      @entries.add(model)



  ## Reporting data
  #
  # For chart building we need a persistent aggregation object
  # that is modified whenever its source data changes.
  # Some of these are expensive so they are all lazy-loaded.
  #
  # It is very likely that all this logic will move into the
  # relevant chart views but this is an easy place to work it out.
  #
  
  ## Total entries
  #
  # TODO there are a lot of loops here. Can we loop once and populate all our data packages?
  #
  setEntryCounts: =>
    @set cancelled_count: @cancelled_entries.length
    @set total_count: @entries.length
    postal_count = 0
    online_count = 0
    club_counts = {}
    cat_counts = {}
    @entries.each (entry) ->
      club_counts[entry.get('club_name')] ?= 0
      club_counts[entry.get('club_name')] += 1
      cat_counts[entry.get('category')] ?= 0
      cat_counts[entry.get('category')] += 1
      if entry.get('paid')
        online_count += 1
      else
        postal_count += 1
    @set
      online_count: online_count
      postal_count: postal_count
    @updateEntryData()
    @updateCategoryData(cat_counts)
    @updateClubData(club_counts)

  updateEntryData: =>
    @set 'entry_data',
      labels: ["postal", "online", "available"]
      series: [
        @get('postal_count'),
        @get('online_count'),
        @get('entry_limit') - @get('total_count')
      ]

  updateCategoryData: (counts) =>
    [f_cats, m_cats] = _.partition @get('category_names'), (c) -> c[0] is 'F'
    # if we have more than one U category then they should be spliced
    # back in ascending same order. f_matches records the next offset.
    f_matches = m_matches = 0
    for c, i in f_cats
      f_cats.splice(f_matches++, 0, f_cats.splice(i, 1)[0]) if c[1] is 'U'
    for c, i in m_cats
      m_cats.splice(m_matches++, 0, m_cats.splice(i, 1)[0]) if c[1] is 'U'

    @set 'cat_data',
      labels: _.map f_cats, (c) -> c.substr(1) || 'S'
      series: [
        _.map f_cats, (c) -> 
          value: counts[c] ? 0
          meta: c
      ,
        _.map m_cats, (c) -> 
          value: counts[c] ? 0
          meta: c
      ]

  updateClubData: (counts) =>
    console.log "updateClubData", counts

  ## Entries by category
  #
  setCategoryData: =>
    @_m_cat_counts ?= {}
    @_f_cat_counts ?= {}
    @_cat_data ?= []
    @_cat_data.length = 0
    for entry in @entries
      if entry.get('gender') is 'm'
        @_m_cat_counts[entry.get('category_name')] ?= 0
        @_m_cat_counts[entry.get('category_name')] += 1
      else
        @_f_cat_counts[entry.get('category_name')] ?= 0
        @_f_cat_counts[entry.get('category_name')] += 1
    # for cat in @get('category_names')
    #...



  clubEntryCounts: =>
    @_club_entry_counts = true
    @clubs ?= new FellRace.Collections.Clubs
    @clubs.comparator = (c) -> -c.get("entry_count")
    @setClubEntryCounts()
    @clubs

  setClubEntryCounts: =>
    @clubs.reset []
    @entries.each (entry) =>
      club = @clubs.findOrAddBy name: entry.get("club_name")
      club.set entry_count: club.get("entry_count") + 1
    @clubs.sort()

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

  calculateClubTotals: =>
    @entries

  formdata: () =>
    formdata = new FormData()
    _.each @attributes, (value, key, list) =>
      unless (key is "file" and not @get("file_changed")) or (key is "entry_form" and not @get("entry_form_changed"))
        formdata.append("instance[#{key}]", value)
    formdata

  sync: (method, model, options) =>
    return super unless @get("file_changed") or @get("entry_form_changed")
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


