class Results.Views.PerformanceRow extends Backgrid.Row
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
