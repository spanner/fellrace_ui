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
    _fellrace.secondsToTime seconds
