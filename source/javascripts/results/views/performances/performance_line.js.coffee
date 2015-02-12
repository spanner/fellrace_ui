class Results.Views.PerformanceLine extends Backbone.Marionette.ItemView
  model: Results.Models.Performance
  tagName: "path"
  className: "line"
  modelEvents:
    "hover": "highlight"
    "unhover": "unhighlight"
    "show": "show"
    "hide": "hide"
    "set_line": "setLine"

  initialize: (options) =>
    @chart = options.chart
    @collection = @model.collection

  render: =>
    @line = @chart.graph.append("svg:path")
      .attr("class", "performance")
      .style("stroke", @model.colour)
      .style("display", "none")
    @setLine()
    @listen()

  listen: =>
    @line.on "mouseover", =>
      @model.trigger "hover"
    @line.on "mouseout", =>
      @model.trigger "unhover"

  setLine: =>
    x = @chart.xScale
    y = @chart.yScale
    line = d3.svg.line()
      .x (d) ->
        x(d.x)
      .y (d) ->
        y(d.y)
    @line.transition().duration(1200).attr("d", line(@model.getCPyValues(@chart.chartType)))

  show: =>
    if @model.getHighest(@chart.chartType) > @chart.y_max and @chart.autoRescaling
      @chart.reScaleHeight()
    @line
      .style("display", null)

  hide: =>
    if @model.getHighest(@chart.chartType) is @chart.y_max and @chart.autoRescaling
      @chart.reScaleHeight()
    @line
      .style("display", "none")

  highlight: =>
    @line
      .style("stroke-width", 8)
      .style("stroke-opacity", 1)

  unhighlight: =>
    @line
      .style("stroke-width", null)
      .style("stroke-opacity", null)

    