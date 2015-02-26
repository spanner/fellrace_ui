class FellRace.Views.FutureInstance extends Backbone.Marionette.ItemView
  template: 'instances/future'
  className: "instance future"

  events:
    "click a.enter": "enter"

  bindings:
    ".date":
      observe: "date"
      onGet: "date"

    "span.entry_limit": "entry_limit"

    ".eod":
      observe: "eod"
      visible: true

    ".eod_fee": "eod_fee"

    ".no_eod":
      observe: "eod"
      visible: "untrue"

    ".pre_entry":
      observe: "pre_entry"
      visible: true

    ".online":
      observe: "online_entry"
      visible: true

    ".postal":
      observe: "postal_entry"
      visible: true

    #online details
    "span.online_entry_fee":
      observe: "online_entry_fee"
      onGet: (fee) =>
        fee?.toFixed(2)
    "span.online_entry_closing": "online_entry_closing"
    "span.online_entry_opening": "online_entry_opening"    

    #postal details
    "span.postal_entry_fee":
      observe: "postal_entry_fee"
      onGet: (fee) =>
        fee?.toFixed(2)
    "span.postal_entry_closing": "postal_entry_closing"
    "span.postal_entry_opening": "postal_entry_opening"    
    "p.postal_entry_address": "postal_entry_address"

    "span.entry_count": "entry_count"

    ".entries":
      observe: "entries"
      visible: "any"

  onRender: =>
    @stickit()
    entries_table = new FellRace.Views.EntriesTable
      collection: @model.entries
      el: @$el.find(".entries")
    entries_table.render()

  enter: =>
    console.log "enter"

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date

  any: (array) =>
    array.length > 0

  untrue: (val) =>
    !val
