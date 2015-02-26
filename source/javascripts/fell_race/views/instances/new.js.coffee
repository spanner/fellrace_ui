class FellRace.Views.NewInstance extends Backbone.Marionette.ItemView
  template: 'instances/new'
  className: "instance new"
  tagName: "section"

  events:
    "click a.save": "save"
    "click a.cancel": "cancel"

  bindings:
    "p.instructions":
      observe: ["date","taken"]
      onGet: "instructions"
      attributes: [
        name: "class"
        observe: ["date","taken"]
        onGet: "instructionsClass"
      ]

    "span.day": "day"        
    "span.month": "month"
    "span.year": "year"

    "a.save":
      observe: ["date","taken"]
      visible: "true_and_false"

  initialize: ->
    $.getJSON "#{_fellrace.apiUrl()}/races/#{@model.get("race_slug")}/instances/taken", (response) =>
      @_dates_taken = response

  onRender: =>
    @$el.find('.editable').editable()
    @stickit()

    @model.on "change:day change:month change:year", () =>
      day = @model.get("day")
      month = @model.get("month")
      year = @model.get("year")

      taken = false
      date_string = null
      if year.length is 4
        d = parseInt(day,10)
        m = parseInt(month,10)
        y = parseInt(year,10)
        date = new Date(y,m-1,d)

        if date.getFullYear() is y and date.getMonth() + 1 is m and date.getDate() is d
          date_string = "#{year}-#{month}-#{day}"
          if _.contains @_dates_taken, date_string
            taken = true
        @model.set
          date: date_string
          taken: taken
      else
        @model.set
          date: null
          taken: taken

  save: =>
    @model.save {},
      success: =>
        @redirect()
      error: =>
        #TODO prompt: try again with different date

  cancel: =>
    _fellrace.navigate "/admin/races/#{@model.get("race_slug")}",
      replace: true

  true_and_false: ([date,taken]=[]) =>
    date and !taken

  instructionsClass: ([date,taken]=[]) =>
    if date
      if taken
        "notready"
      else
        "okay"

  instructions: ([date,taken]=[]) =>
    if date
      if taken
        "You've already created an instance for this date."
      else
        "This looks okay!"
    else
      "Please enter a date for this instance."

  redirect: =>
    _fellrace.navigate "/admin/races/#{@model.get("race_slug")}/#{@model.get("name")}"
