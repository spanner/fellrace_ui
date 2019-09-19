class FellRace.Views.NewInstance extends FellRace.View
  template: 'instances/new'
  className: "instance new"
  tagName: "section"
  storage_date_format: "YYYY-MM-DD"
  display_date_format: "Do MMM YYYY"

  events:
    "click a.save": "save"

  bindings:
    "span.race_name": "race_name"
    "input#name":
      observe: "name"
      onGet: "deSlugify"
      onSet: "slugify"

    "span.taken":
      observe: "name"
      visible: "taken"

    ".name":
      observe: "date"
      visible: "hasDate"

    "input#date":
      observe: "date"
      onSet: "dateForStorage"
      onGet: "dateForDisplay"

    "span.name_info":
      observe: "name"
      visible: "absent"

    "span.year":
      observe: "date"
      onGet: "year"

    "a.close":
      attributes: [
        observe: "race_slug"
        name: "href"
        onGet: "raceUrl"
      ]

    "a.cancel":
      attributes: [
        observe: "race_slug"
        name: "href"
        onGet: "raceUrl"
      ]

    "a.save":
      observe: ["date","name"]
      visible: "both"

  _names_taken: []

  initialize: ->
    $.getJSON "#{_fr.apiUrl()}/races/#{@model.get("race_slug")}/instances/taken", (response) =>
      @_names_taken = response
    @model.on "change:date", @setName

  onRender: =>
    @$el.find('.editable').editable()
    @stickit()
    Backbone.Validation.bind(@)

    @$el.find('input.date').each (i, el) =>
      picker = $(el)
      new Pikaday
        field: el
        format: @display_date_format

  save: =>
    @model.save {},
      success: @redirect

  both: ([date,name]=[]) =>
    date and name and name not in @_names_taken

  setName: (model, date) =>
    name = model.get("name")
    unless name and name not in @_names_taken
      if year = date?.getFullYear()
        name = "#{year}" if 1800 < year < 2200
      model.set name: name or null

  raceUrl: (slug) ->
    "/admin/races/#{slug}"

  redirect: =>
    _fr.navigate "/admin/races/#{@model.get("race_slug")}/#{@model.get("name")}"

  dateForDisplay: (string) =>
    new moment(string, @storage_date_format).format(@display_date_format) if string

  dateForStorage: (string) =>
    new moment(string, @display_date_format).toDate()

  taken: (name) =>
    name in @_names_taken

  absent: (name) =>
    !name

  hasDate: (date) =>
    date = @dateForStorage(date) if typeof(date) is "string"
    date and date.getFullYear() > 0

  year: (date) =>
    if date
      date = @dateForStorage(date) if typeof(date) is "string"
      "(#{date.getFullYear()})"

  deSlugify: (string) ->
    _.str.capitalize(string.split("-").join(" ")) if string

  slugify: (string) ->
    _.str.slugify(string.trim()) if string

  onClose: =>
    $(".pika-single").remove()
