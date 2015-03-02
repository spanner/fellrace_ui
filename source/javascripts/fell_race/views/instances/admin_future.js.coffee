class FellRace.Views.AdminFutureInstance extends Backbone.Marionette.ItemView
  template: 'instances/admin_future'
  className: "instance future admin"
  tagName: "section"

  events:
    'click a.delete': "delete"

  bindings:
    ".race_name": "race_name"
    ".instance_name": "name"
    "span.date": "date"
    "span.time": "time"
    "span.entry_limit": "entry_limit"

    "input#eod": "eod"
    ".eod_details":
      observe: "eod"
      visible: true
      visibleFn: "quickSlide"
    "span.eod_fee":
      observe: "eod_fee"
      onGet: "currency"

    "input#online_entry": "online_entry"
    ".online_details":
      observe: "online_entry"
      visible: true
      visibleFn: "quickSlide"
    "span.online_entry_fee":
      observe: "online_entry_fee"
      onGet: "currency"
    "span.admin_charge":
      observe: "online_entry_fee"
      onGet: "adminCharge"
    "span.online_entry_closing": "online_entry_closing"
    "span.online_entry_opening": "online_entry_opening"    

    "input#postal_entry": "postal_entry"
    ".postal_details":
      observe: "postal_entry"
      visible: true
      visibleFn: "quickSlide"
    "span.postal_entry_fee":
      observe: "postal_entry_fee"
      onGet: "currency"
    "span.postal_entry_closing": "postal_entry_closing"
    "span.postal_entry_opening": "postal_entry_opening"    
    "span.postal_entry_address": "postal_entry_address"
    "input.accept_cheque": "accept_cheque"
    "input.cheque_paid_to": "cheque_paid_to"
    "input.accept_cash": "accept_cash"

    "span.total_count": "total_count"
    "span.completed_count": "completed_count"
    "span.pending_count": "pending_count"

    "a.close":
      attributes: [
        observe: "race_slug"
        name: "href"
        onGet: "raceUrl"
      ]


  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

    entry_form = new FellRace.Views.AdminPostalEntryForm
      model: @model
      el: @$el.find(".entry_form")
    entry_form.render()

    entries_table = new FellRace.Views.AdminEntriesTable
      collection: @model.entries
      el: @$el.find("table.entries")
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

  quickSlide: ($el, isVisible, options) =>
    if (isVisible) then $el.slideDown('fast') else $el.slideUp('fast')
