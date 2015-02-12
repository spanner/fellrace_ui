class FellRace.Views.Instance extends Backbone.Marionette.ItemView
  template: 'instances/show'
  className: "instance"

  events:
    'click a.upload_file': "pickFile"
    'change input[type="file"]': "filePicked"
    # 'click a.remove_file': "deleteFile"
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

    "a.upload_file":
      observe: "file_name"
      visible: "untrue"
    "a.remove_file":
      observe: "file_name"
      visible: true

    "span.file_name": "file_name"
    "p.report": "summary"
    "span.total":
      observe: "performances_count"
      onGet: "summarise"

  onRender: () =>
    if @model.isNew()
      @model.once "sync", (model,attributes) =>
        _fellrace.navigate @url(attributes.name),
          replace:true
          trigger:false
        @onChangeName()
    else
      @onChangeName()

    @manageDate()

    @_filefield = @$el.find('input[type="file"]')
    @$el.find('.editable').editable()
    @stickit()

  manageDate: =>
    if date = @model.get("date")
      @model.onSetDate(date)
    @model.on "change:date", (model, value, opts) =>
      @model.onSetDate(value) if value

    @model.on "change:day change:month change:year", =>
      day = @model.get("day")
      month = @model.get("month")
      year = @model.get("year")
      if _.any @model.collection.inYearExcept(year,@model)
        $.notify "error", "There is already an instance for #{year}; not saving."
      else if day and month and year and year.length is 4
        @model.set date: "#{year}-#{month}-#{day}"

  pickFile: =>
    @_filefield.trigger('click')

  filePicked: (e) =>
    if files = @_filefield[0].files
      @model.set file: files.item(0)

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  receivedFee: (fee) =>
    fee ?= 0
    merchant_ratio = 0.034
    merchant_fixed = 0.02
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
    @model.on "change:name", (model,name) =>
      _fellrace.navigate @url(name),
        replace: true
        trigger: false

  url: (name) =>
    "/events/#{@model.event.get("slug")}/#{@model.race.get("slug")}/#{name}/admin"

  goto: (e) =>
    window.location.href = "/#{@model.get('name')}"

  summarise: (value, options) =>
    if !value?
      ""
    else if value == "processing"
      "calculating"
    else
      "#{value} runners"

  untrue: (val) ->
    !val
