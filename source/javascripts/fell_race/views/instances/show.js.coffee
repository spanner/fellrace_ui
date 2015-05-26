class FellRace.Views.Instance extends Backbone.Marionette.ItemView
  template: 'instances/show'
  className: "instance"

  bindings:
    "#past":
      observe: "date"
      visible: "isPast"
    "#future":
      observe: "date"
      visible: "isFuture"
    "#entry_details":
      observe: "online_entry"
      visible: true
    "span.entry_limit": "entry_limit"
    "span.entry_fee":
      observe: "entry_fee"
      onGet: (fee) =>
        fee.toFixed(2) if fee
    "span.enter":
      observe: ["entry_closing","entry_opening"]
      visible: "canEnter"
    "span.entry_open_close":
      observe: ["entry_closing","entry_opening"]
      onGet: "entryClosing"
    "span.name": "name"
    "span.day":
      observe: "date"
      onGet: "day"
    "span.month":
      observe: "date"
      onGet: "month"
    "span.year":
      observe: "date"
      onGet: "year"
    "span.time": "time"
    "p.report": "report"
    "span.summary": "summary"
    "span.total": 
      observe: "performances_count"
      onGet: "summarise"

  onRender: () =>
    console.log "*** show render"
    @stickit()
    if @model.inFuture() and @model.get("online_entry")
      entries_table = new FellRace.Views.EntriesTable
        collection: @model.entries
        el: @$el.find(".entries")
      entries_table.render()
      @model.entries.url = "/api/instances/#{@model.id}/entries"
      @model.entries.fetch()

  isPast: (date) =>
    date and new Date(date) <= new Date()

  isFuture: (date) =>
    date and new Date(date) > new Date()

  summarise: (value, options) =>
    if !value?
      ""
    else
      "#{value} runners"

  day: (date) =>
    date.split("-")[2]

  month: (date) =>
    date.split("-")[1]

  year: (date) =>
    date.split("-")[0]

  canEnter: ([closing,opening]=[]) =>
    
    # if Date.parse(opening) < Date.now() and Date.parse(closing) > Date.now()

  entryOpening: ([closing,opening]=[]) =>
    if Date.parse(opening) < Date.now()
      "Entries are open"
    
