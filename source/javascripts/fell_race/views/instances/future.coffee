class FellRace.Views.FutureInstance extends Backbone.Marionette.ItemView
  template: 'instances/future'
  className: "instance future"

  bindings:
    ".entry_count": "total_count"
    ".race_name":
      observe: "race_name"
      attributes: [
        observe: "race_slug"
        name: "href"
        onGet: "racePublicationUrl"
      ]

    ".instance_name":
      observe: "name"
      onGet: "deSlugify"

    "a.close":
      attributes: [
        observe: "race_slug"
        name: "href"
        onGet: "racePublicationUrl"
      ]

    "a.edit":
      observe: "permissions"
      onGet: ({can_edit:can_edit}={}) -> can_edit
      visible: true
      attributes: [
        observe: ["race_slug","name"]
        name: "href"
        onGet: "adminUrl"
      ]

    ".race_date":
      observe: "date"
      onGet: "date"
    "span.time": "time"

    "span.entry_limit": "entry_limit"
    ".limit":
      observe: "entry_limit"
      visible: true

    ".full":
      observe: ["entry_limit","total_count"]
      onGet: "full"
      visible: true
    ".not_full":
      observe: ["entry_limit","total_count"]
      onGet: "full"
      visible: "untrue"
    "p.no_eod":
      observe: "eod"
      visible: "untrue"
    "p.eod":
      observe: "eod"
      visible: true
    "p.online":
      observe: "online_entry_active"
      visible: true
    "p.postal":
      observe: "postal_entry_active"
      visible: true

    #eod details
    ".eod_fee":
      observe: "eod_fee"
      onGet: "currency"

    #online details
    "span.online_entry_fee":
      observe: "online_entry_fee"
      onGet: "currency"

    "a.enter":
      observe: ['online_entry_active', "entered"]
      onGet: (vals) -> vals[0] and not vals[1]
      visible: true
      attributes: [
        name: "href"
        observe: ["race_slug","name"]
        onGet: "entryUrl"
      ]

    "span.online_entry_opening":
      observe: "online_entry_opening"
      onGet: "date"
    "span.online_entry_closing":
      observe: "online_entry_closing"
      onGet: "date"

    "span.postal_entry_opening":
      observe: "postal_entry_opening"
      onGet: "date"
    "span.postal_entry_closing":
      observe: "postal_entry_closing"
      onGet: "date"

    "span.postal_entry_fee":
      observe: "postal_entry_fee"
      onGet: "currency"

    "span.postal_entry_address": "postal_entry_address"
    "p.postal_entry_address":
      observe: "postal_entry_active"
      visible: true

    "p.postal_form":
      observe: "postal_entry_active"
      visible: true

    'a.postal_form':
      attributes: [
        name: "href"
        observe: "entry_form"
        onGet: "entryFormUrl"
      ,
        name: "class"
        observe: "entry_form_type"
      ]
    ".total_count": "total_count"
    ".entries":
      observe: "total_entries"
      visible: "some"

  onRender: =>
    $.in = @model
    @stickit()
    if _fr.userConfirmed() and @model.entries.findWhere(competitor_id: _fr.getCurrentCompetitor().id)
      @model.set entered:true
    # @$el.find('.entry_count').text(@model.entries.size())
    @renderEntries() if @model.entries?.length
    @renderClubChart() if @model.get('club_data')
    @renderCatCharts() if @model.get('cat_data')

    @model.entries.on "reset add remove", @renderEntries
    @model.on "change:club_data", @renderClubChart
    @model.on "change:cat_data", @renderCatCharts
    # this old version of marionette seems to leave a render gap, so we wait for the DOM to arrive.
    _.defer @model.setEntryCounts
    # hacky shortcut this, to bring down any wait spinners we have scattered around. Do it properly!
    _fr.vent.trigger 'loaded'

  renderClubChart: (model, data) =>
    @_clubs_chart = new Chartist.Pie '.clubs_chart.ct-chart', @model.get('club_data'),
      donut: true
      donutWidth: 40
      startAngle: 0
      showLabel: true
      plugins: [
        Chartist.plugins.tooltip()
      ]

  renderCatCharts: (model, data) =>
    @_cat_chart = new Chartist.Bar '.categories_chart.ct-chart', @model.get('cat_data'),
      stackBars: true
      chartPadding:
        top: 15
        right: 15
        bottom: 5
        left: 10
      axisY:
        offset: 0
        showGrid: false
        showLabel: false
      axisX:
        offset: 30
        showGrid: false
      plugins: [
        Chartist.plugins.tooltip()
      ]

  renderEntries: () =>
    entries_table = new FellRace.Views.EntriesTable
      collection: @model.entries
      el: @$el.find("table.entries")
    entries_table.render()

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date

  some: (val) =>
    val > 0

  untrue: (val) =>
    !val

  racePublicationUrl: (slug) =>
    "/races/#{slug}"

  entryUrl: ([slug,name]) =>
    "/races/#{slug}/#{name}/enter"

  adminUrl: ([slug,name]) =>
    "/admin/races/#{slug}/#{name}"

  full: ([limit,count]=[]) ->
    limit and count >= limit

  currency: (fee) ->
    fee?.toFixed(2)

  entryFormUrl: (url) =>
    if url
      if url.match(/^\//)
        "#{_fr.apiUrl()}#{url}"
      else
        url

  deSlugify: (string) ->
    string.split("-").map((w) -> _.str.capitalize(w)).join(" ") if string
