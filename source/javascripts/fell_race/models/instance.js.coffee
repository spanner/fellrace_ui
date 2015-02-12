class FellRace.Models.Instance extends Backbone.Model
  defaults:
    total_entries: 0
    file: null
    performances_count: null
  unsynced: []

  synced: ["date","time","entry_fee","entry_limit","summary","started_at","name","file","file_delete","entry_closing","entry_opening"]

  url: =>
    if @race
      "#{@race.url()}/instances/#{@get("name")}"
    else
      "#{_fellrace.apiUrl()}/instances/#{@id}"

  initialize: (opts,{race:@race}={}) ->
    # separate datetime into date and time or use a single control?
    # @save_soon = _.debounce @save, 500
    # _.each @synced, (key) =>
    #   @on "change:#{key}", (model, value, options) =>
    #     @save_soon() unless options.quiet

    @build()

  build: =>
    @buildRace()
    @buildPerformances()
    @buildWinner()

    @entries = new FellRace.Collections.Entries([],{instance:@,url:"#{@url}/entries"})
    @entries.on "change", () =>
      @set total_entries: @entries.length

  buildRace: =>
    unless @race
      if @collection and @collection.race
        @race = @collection.race 
      else
        @race = new FellRace.Models.Race(@get("race"))
    @on "change:race", (model,race) =>
      @race.clear(silent:true)
      @race.set race

  buildPerformances: =>
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @
    @on "change:performances", (model, performances) =>
      @performances.reset performances

  buildWinner: =>
    @winner = new FellRace.Models.Competitor(@get("winner"))
    @on "change:winner", (model,winner) =>
      @winner.clear()
      @winner.set winner

  filename: () =>
    @get('file')?.name

  getYearFromFilename: =>
    if @get('file')? and not @get('name')
      re = new RegExp(/(\d+)/)
      year = re.exec(@filename())[0]
      # started_at = moment("#{@event.get("date")} #{@race.get("start_time")}","DD MMM YYYY HH:mma").year(year)
      @set
        name: year
        # started_at: started_at

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
    "/#{@race.get "slug"}/#{@get "name"}" if @race

  getRaceName: =>
    @race.get("name")

  getRaceSlug: =>
    @race.get("slug")

  getPerformancesCount: =>
    @get "performances_count"

  onSetDate: (val) =>
    @setClosingDate()
    date = val.split "-"
    @set
      day: date[2]
      month: date[1]
      year: date[0]
      name: date[0]#"#{date[2]}_#{date[1]}_#{date[0]}"

  getDate: =>
    if date = @get("date")
      Date.parse(date)

  setClosingDate: =>
    unless @get("entry_closing") and Date.parse(@get("entry_closing")) < Date.parse(@get("date"))
      @set(entry_closing: new Date(@get("date")))

  inFuture: =>
    if date = @getDate()
      date > Date.now()

  inPast: =>
    if date = @getDate()
      date < Date.now()

  