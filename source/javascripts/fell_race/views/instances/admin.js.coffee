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
    "#more_details":
      observe: "name"
      visible: true
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

    "span.name": "name"
    "span.day": "day"        
    "span.month": "month"
    "span.year": "year"
    "span.time": "time"

    "p.report": "summary"
    "span.total":
      observe: "performances_count"
      onGet: "summarise"

  onRender: () =>
    @onChangeName()
    @manageDate()

    new FellRace.Views.ResultsFile(model: @model, el: @$el.find(".results_file")).render()

    new FellRace.Views.ResultsPreview(model:@model, el: @$el.find(".results_preview")).render()

    # @_filefield = @$el.find('input[type="file"]')
    @$el.find('.editable').editable()
    @stickit()

  manageDate: =>
    if date = @model.get("date")
      @model.onSetDate(date)
    @model.on "change:date", (model, value, opts) =>
      @model.onSetDate(value,opts) if value

    @model.on "change:day change:month change:year", (model,value,opts) =>
      day = @model.get("day")
      month = @model.get("month")
      year = @model.get("year")
      if year
        if _.any @model.collection.inYearExcept(year,@model)
          $.notify "error", "There is already an instance for #{year}; not saving."
        else if day and month and year.length is 4
          @model.set {date: "#{year}-#{month}-#{day}"},
            opts
  #
  # pickFile: =>
  #   @_filefield.trigger('click')

  filePicked: (e) =>
    if files = @_filefield[0].files
      console.log files.item(0)
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

  onChangeName: =>
    if @model.isNew()
      @model.once "change:name", (model,name) =>
        @model.save {},
          success: =>
            @redirect(name)
            @onChangeName()
    else
      @model.on "change:name", (model,name) =>
        @redirect(name)

  redirect: (name) =>
    _fellrace.navigate @url(name),
      replace: true
      trigger: false

  url: (name) =>
    "/admin/races/#{@model.get("race_slug")}/#{name}"

  summarise: (value, options) =>
    if !value?
      ""
    else if value == "processing"
      "calculating"
    else
      "#{value} runners"

  untrue: (val) ->
    !val
