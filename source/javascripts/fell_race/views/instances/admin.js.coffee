class FellRace.Views.AdminInstance extends Backbone.Marionette.ItemView
  template: 'instances/admin'
  className: "instance"
  tagName: "section"

  events:
    'click a.delete': "delete"

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

    "input.online_entry": "online_entry"
    "span.entry_limit": "entry_limit"
    "span.entry_fee":
      observe: "entry_fee"
      onGet: (fee) =>
        fee?.toFixed(2)
    "span.received_fee":
      observe: "entry_fee"
      onGet: "receivedFee"
    "span.entry_closing": "entry_closing"
    "span.entry_opening": "entry_opening"    

    "h3.date":
      observe: "date"
      onGet: "date"

    "span.time": "time"

    "p.report": "summary"
    "span.total":
      observe: "performances_count"
      onGet: "summarise"

  onRender: () =>
    new FellRace.Views.ResultsFile(model: @model, el: @$el.find(".results_file")).render()

    new FellRace.Views.ResultsPreview(model:@model, el: @$el.find(".results_preview")).render()

    @$el.find('.editable').editable()
    @stickit()

  filePicked: (e) =>
    if files = @_filefield[0].files
      @model.set file: files.item(0),
        persistChange: true

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  receivedFee: (fee) =>
    fee ?= 0
    merchant_ratio = 0.024
    merchant_fixed = 0.2
    fr_ratio = 0.05
    fr_fixed = 0.05
    # if fee <= 9.37
    #   merchant_ratio = 0.05
    #   merchant_fixed = 0.05
    ratio = merchant_ratio + fr_ratio
    fixed = merchant_fixed + fr_fixed
    received = 0
    if fee > fixed
      received = (fee - (fee * ratio) - fixed).toFixed(4)
    (Math.floor(received * 100) / 100).toFixed(2)

  isPast: (date) =>
    date and Date.parse(date) <= Date.now()

  isFuture: (date) =>
    date and Date.parse(date) > Date.now()

  summarise: (value, options) =>
    if !value?
      ""
    else if value == "processing"
      "calculating"
    else
      "#{value} runners"

  untrue: (val) ->
    !val

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date
