class FellRace.Views.AdminFutureInstance extends Backbone.Marionette.ItemView
  template: 'instances/admin_future'
  className: "instance future admin"
  tagName: "section"

  events:
    'click a.delete': "delete"

  bindings:
    "a.close":
      attributes: [
        observe: "race_slug"
        name: "href"
        onGet: "raceUrl"
      ]

    "h3.date":
      observe: "date"
      onGet: "date"
    "span.time": "time"

    "span.entry_limit": "entry_limit"

    "input#eod": "eod"

    "#eod_details":
      observe: "eod"
      visible: true

    "input#pre_entry": "pre_entry"
    "#pre_entry_details":
      observe: "pre_entry"
      visible: true

    "input#online_entry": "online_entry"
    "#online_entry_details":
      observe: "online_entry"
      visible: true

    "input#postal_entry": "postal_entry"
    "#postal_entry_details":
      observe: "postal_entry"
      visible: true

    #eod details
    "span.eod_fee":
      observe: "eod_fee"
      onGet: "currency"

    #online details
    "span.online_entry_fee":
      observe: "online_entry_fee"
      onGet: "currency"
    "span.admin_charge":
      observe: "online_entry_fee"
      onGet: "adminCharge"
    "span.online_entry_closing": "online_entry_closing"
    "span.online_entry_opening": "online_entry_opening"    

    #postal details
    "span.postal_entry_fee":
      observe: "postal_entry_fee"
      onGet: "currency"
    "span.postal_entry_closing": "postal_entry_closing"
    "span.postal_entry_opening": "postal_entry_opening"    
    "p.postal_entry_address": "postal_entry_address"
    "input.accept_cheque": "accept_cheque"
    "input.cheque_paid_to": "cheque_paid_to"
    "input.accept_cash": "accept_cash"

    ".entries":
      observe: "pre_entry"
      visible: true

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

    entry_form = new FellRace.Views.AdminPostalEntryForm
      model: @model
      el: @$el.find(".entry_form")
    entry_form.render()

    entries_table = new FellRace.Views.AdminEntriesTable
      collection: @model.entries
      el: @$el.find(".entries")
    entries_table.render()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  adminCharge: (fee) ->
    fee ?= 0
    merchant_ratio = 0.024
    merchant_fixed = 0.2
    fr_ratio = 0.025
    fr_fixed = 0
    ratio = merchant_ratio + fr_ratio
    fixed = merchant_fixed + fr_fixed
    charge = 0
    if fee > fixed
      charge = (fee * ratio + fixed).toFixed(4)
    @currency (Math.ceil(charge * 100) / 100)

  date: (date) ->
    moment(date).format("D MMMM YYYY") if date

  raceUrl: (slug) ->
    "/admin/races/#{slug}"

  currency: (amount) ->
    amount?.toFixed(2)
