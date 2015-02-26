class FellRace.Views.ResultRow extends Backgrid.Row
  bindings:
    ":el":
      attributes: [
        observe: "current"
        name: "class"
        onGet: (current) =>
          "current" if current
      ]

  initialize: ->
    super
    if @model.get("cat")?.match /[lfw]/i
      @$el.addClass "female"
    @$el.on "mouseenter", =>
      @model.trigger "hover"
    @$el.on "mouseleave", =>
      @model.trigger "unhover"
    @model.on "hover", @highlight
    @model.on "unhover", @unhighlight

  highlight: =>
    @$el.addClass "hover"

  unhighlight: =>
    @$el.removeClass "hover"

  render: =>
    super
    @stickit()
    @$el.find(".select-row-cell").css
      background: @model.colour
    @

class FellRace.Views.ResultsTable extends Backgrid.Grid
  tagName: 'table'
  className: 'backgrid'

class FellRace.Views.TimeCell extends Backbone.Marionette.ItemView
  template: "performances/time_cell"
  className: "time"
  tagName: "td"

  bindings:
    ".time":
      observe: "time"
      onGet: "time"

  onRender: =>
    @stickit()

  time: (seconds) =>
    _fellrace.secondsToString seconds

class FellRace.Views.NameCell extends Backbone.Marionette.ItemView
  template: "performances/name_cell"
  className: "runner"
  tagName: "td"

  bindings:
    "span.name":
      observe: ["competitor_id","forename","middlename","surname"]
      onGet: "perfFullName"

    "a.name":
      observe: ["competitor_id","competitor_forename","competitor_middlename","competitor_surname"]
      onGet: "compFullName"
      attributes: [
        {
          name: "href"
          observe: "competitor_id"
          onGet: "url"
        }
      ]

  onRender: =>
    @_instance = @model.instance
    @stickit()

  compFullName: ([id,first,middle,last]=[]) =>
    @fullName([first,middle,last]) if id

  perfFullName: ([id,first,middle,last]=[]) =>
    @fullName([first,middle,last]) unless id

  fullName: ([first,middle,last]=[]) =>
    name = first
    name = "#{name} #{middle}" if middle
    "#{name} #{last}"

  url: (id) =>
    "/runners/#{id}/#{@raceSlug()}/#{@instanceName()}"

  raceSlug: =>
    @_instance.get("race_slug")

  instanceName: =>
    @_instance.get("name")
