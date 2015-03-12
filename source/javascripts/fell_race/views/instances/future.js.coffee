class FellRace.Views.FutureInstance extends Backbone.Marionette.ItemView
  template: 'instances/future'
  className: "instance future"

  bindings:
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
      observe: ["entry_limit","entries_count"]
      onGet: "full"
      visible: true
    ".not_full":
      observe: ["entry_limit","entries_count"]
      onGet: "full"
      visible: "untrue"
    "p.no_eod":
      observe: "eod"
      visible: "untrue"
    "p.eod":
      observe: "eod"
      visible: true
    "p.online":
      observe: "online_entry"
      visible: true
    "p.postal":
      observe: "postal_entry"
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
      observe: ['online_entry_active',"entered"]
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

    ".entries":
      observe: "entry_count"
      visible: "some"

  onRender: =>
    @stickit()
    if _fellrace.userConfirmed() and @model.entries.findWhere(competitor_id: _fellrace.getCurrentCompetitor().id)
      @model.set entered:true
    entries_table = new FellRace.Views.EntriesTable
      collection: @model.entries
      el: @$el.find("table.entries")
    entries_table.render()
    @$el.find('.entry_count').text(@model.entries.size())

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
        "#{_fellrace.apiUrl()}#{url}"
      else
        url

  deSlugify: (string) ->
    string.split("-").map((w) -> _.str.capitalize(w)).join(" ") if string
