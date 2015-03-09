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

    ".date":
      observe: "date"
      onGet: "date"

    "span.time": "time"

    "span.entry_limit": "entry_limit"

    ".limit":
      observe: "entry_limit"
      visible: true

    "p.full":
      observe: ["entry_limit","entries_count"]
      onGet: "full"
      visible: true

    "p.nearly_full":
      observe: ["entry_limit","entries_count"]
      onGet: "nearlyFull"
      visible: true

    ".not_full":
      observe: ["entry_limit","entries_count"]
      onGet: "notFull"
      visible: true

    "section.eod":
      observe: "eod"
      visible: true

    "section.online":
      observe: "online_entry"
      visible: true

    "section.postal":
      observe: "postal_entry"
      visible: true

    ".no_eod":
      observe: "eod"
      visible: "untrue"

    ".no_online":
      observe: "online_entry"
      visible: "untrue"

    ".no_postal":
      observe: "postal_entry"
      visible: "untrue"

    #eod details
    ".eod_fee": "eod_fee"

    #online details
    "span.online_entry_fee":
      observe: "online_entry_fee"
      onGet: (fee) =>
        fee?.toFixed(2)
    "span.online_dates":
      observe: ['online_entry_opening', 'online_entry_closing']
      onGet: "showDates"

    "p.enter":
      observe: 'online_entry_active'
      visible: true

    "a.enter":
      attributes: [
        name: "href"
        observe: ["race_slug","name"]
        onGet: "entryUrl"
      ]

    #postal details
    "span.postal_entry_fee":
      observe: "postal_entry_fee"
      onGet: (fee) =>
        fee?.toFixed(2)
    "span.postal_dates":
      observe: ['postal_entry_opening', 'postal_entry_closing']
      onGet: "showDates"

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
    entries_table = new FellRace.Views.EntriesTable
      collection: @model.entries
      el: @$el.find("table.entries")
    entries_table.render()
    @$el.find('.entry_count').text(@model.entries.size())

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date

  some: (entry_count) =>
    entry_count > 0

  untrue: (val) =>
    !val

  racePublicationUrl: (slug) =>
    "/races/#{slug}"

  entryUrl: ([slug,name]) =>
    "/races/#{slug}/#{name}/enter"

  adminUrl: ([slug,name]) =>
    "/admin/races/#{slug}/#{name}"

  full: ([limit,count]=[]) ->
    count >= limit

  nearlyFull: ([limit,count]=[]) ->
    count >= limit * 0.85

  notFull: ([limit,count]=[]) ->
    count < limit

  showDates: ([start,end]=[]) =>
    @dateRangeString(start, end)
      
  simpleDateRangeString: (start, end) =>
    if start? and end?
      start = moment(start)
      end = moment(end)
      "#{start.format(@date_format)} to #{end.format(@date_format)}"

  dateRangeString: (start, end) =>
    if start? and end?
      start = moment(start)
      end = moment(end)
      if start.year() is end.year() 
        if start.month() is end.month()
          start_format = "Do"
          end_format = "Do MMM YYYY"
        else
          start_format = "Do MMM"
          end_format = "Do MMM YYYY"
      else
        start_format = end_format = "Do MMM YYYY"
      "#{start.format(start_format)} to #{end.format(end_format)}"
    else
      "Please choose dates"

  entryFormUrl: (url) =>
    if url
      if url.match(/^\//)
        "#{_fellrace.apiUrl()}#{url}"
      else
        url

  deSlugify: (string) ->
    string.split("-").map((w) -> _.str.capitalize(w)).join(" ") if string
