class FellRace.Views.ResultRow extends Backgrid.Row
  initialize: =>
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
      observe: ["forename","middlename","surname"]
      onGet: "fullName"

  competitor_bindings:
    "a.competitor_name":
      observe: ["forename","middlename","surname"]
      onGet: "fullName"
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: "url"
        }
      ]

  onRender: =>
    @_instance = @model.instance
    if @model.has("competitor")
      @stickit(new FellRace.Models.Competitor(@model.get("competitor")), @competitor_bindings)
    else
      @stickit()

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
