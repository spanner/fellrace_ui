class FellRace.Views.AdminFutureInstance extends Backbone.Marionette.ItemView
  template: 'instances/admin_future'
  className: "instance future admin"
  tagName: "section"
  date_format: "YYYY-MM-D"

  events:
    'click a.delete': "delete"

  bindings:
    ".race_name": "race_name"
    ".instance_name": "name"
    "span.date": 
      observe: "date"
      onGet: "showDate"
    "span.time": "time"
    "span.entry_limit": "entry_limit"

    "input#eod": "eod"
    ".eod_details":
      observe: "eod"
      visible: true
    "span.eod_fee":
      observe: "eod_fee"
      onGet: "currency"

    "input#online_entry": "online_entry"
    ".online_details":
      observe: "online_entry"
      visible: true
      # visibleFn: "quickSlide"
    "span.online_entry_fee":
      observe: "online_entry_fee"
      onGet: "currency"
    "span.admin_charge":
      observe: "online_entry_fee"
      onGet: "adminCharge"

    "input#postal_entry": "postal_entry"
    ".postal_details":
      observe: "postal_entry"
      visible: true
      # visibleFn: "quickSlide"
    "span.postal_entry_fee":
      observe: "postal_entry_fee"
      onGet: "currency"
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

    "span.postal_dates":
      observe: ['postal_entry_opening', 'postal_entry_closing']
      onGet: "showDates"

    "span.online_dates":
      observe: ['online_entry_opening', 'online_entry_closing']
      onGet: "showDates"

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()
    
    @$el.find('span.date').each (i, el) =>
      field = $(el)
      att = field.data('attribute') ? "date"
      container = $('<div class="datepicker" />').prependTo(field.parents('div').first())
      field.dateRangePicker
        inline: true
        container: container.get(0)
        format: @date_format
        alwaysOpen: true
        showShortcuts: false
        singleDate: true
        setValue: (s) =>
          @model.set att, s
        getValue: () =>
          @showDate(@model.get(att)) if @model.get(att)?

    @$el.find('span.daterange').each (i, el) =>
      field = $(el)
      [start_att, end_att] = field.data('attributes').split(',')
      container = $('<div class="daterangepicker" />').prependTo(field.parents('div').first())
      field.dateRangePicker
        inline: true
        container: container.get(0)
        format: @date_format
        alwaysOpen: true
        showShortcuts: false
        setValue: (s, start, end) =>
          @model.set start_att, start
          @model.set end_att, end
        getValue: () =>
          @simpleDateRangeString(@model.get(start_att), @model.get(end_att))
      
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

  raceUrl: (slug) ->
    "/admin/races/#{slug}"

  currency: (amount) ->
    amount?.toFixed(2)

  quickSlide: ($el, isVisible, options) =>
    if (isVisible) then $el.slideDown('fast') else $el.slideUp('fast')

  showDate: (date) =>
    moment(date).format(@date_format)

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
