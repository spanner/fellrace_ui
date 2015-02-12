class Results.Views.PerformancesChart extends Backbone.View
  el: "#chart"

  initialize: ->
    instance = @collection.instance
    # @results = options.results
    @ideal_time = @model.get "ideal_time"
    @table = $("#table")
    @chartType = "elapsed_time"
    @checkpoints = @collection["checkpoints"] = @model.get "checkpoints"
    @m = [20,20,30,90] #margins
    @getElementWidth()
    @getElementHeight()
    @selectChartType()
    @drawGraph()
    $(window).on "resize", =>
      @resizeGraph()

  showGraph: =>
    @$el.css
      height: "70%"
    @table.css
      height: "30%"
    @resizeGraph()

  hideGraph: =>
    @$el.css
      height: ""
    @table.css
      height: ""

  selectChartType: =>
    selector = $("#chart-select").on "change", (e) =>
      type = e.target.value
      if type is "none"
        @hideGraph()
      else
        @showGraph()
        @chartType = type
        @reScaleHeight()

  setXScale: =>
    w = @elWidth - @m[1] - @m[3]
    @xScale = d3.scale.linear().domain([0, @ideal_time]).range([0, w])

  setYScale: (y_max) =>
    h = @elHeight - @m[0] - @m[2]
    y_min = @chartType is "elapsed_time" ? 0 : 1
    y_max = y_max - @ideal_time if @chartType is "elapsed_time"
    @yScale = d3.scale.linear().domain([y_min, y_max]).range([0, h])

  getElementWidth: =>
    @elWidth = @$el.width()

  getElementHeight: =>
    @elHeight = @$el.height()

  resizeGraph: =>
    @graph
      .attr("width", "100%")
      .attr("height", "100%")
    @reScaleWidth()
    @moveCheckpoints()
    @reScaleHeight()

  drawGraph: =>
    @graph = d3.select("#chart").append("svg:svg")
      .attr("class", "performances_graph")
      .append("svg:g")
      .attr("transform", "translate(" + @m[3] + "," + @m[0] + ")")
    @y_max = 0
    @setYScale @y_max
    @setXScale()

    # Add the checkpoint labels.
    @cp_labels = []
    _.each @checkpoints, (cp) =>
      c = {}
      c["label"] = @graph.append("svg:text")
        .text(cp.name)
        .attr("transform", "translate(-35,15)")
      c["divider"] = @graph.append("svg:line")
        .attr("class", "cp_divider")
        .attr("y1", 0)
      @cp_labels.push c
    @moveCheckpoints()

    # Add the y-axis
    @yAxis = @graph.append("svg:g")
      .attr("class", "y axis")
      .attr("transform", "translate(-25,0)")

    @resizeGraph()

    @scaleYAxis()

    @createLines()
    @autoRescaling = true
    $(".select-all-header-cell input").on "mousedown", (e) =>
      @autoRescaling = false
    $(".select-all-header-cell input").click (e) =>
      @reScaleHeight()
      @autoRescaling = true

    @collection.on "backgrid:selected", (perf, selected) =>
      if selected
        perf.set "selected", true
        perf.trigger "show"
      else
        perf.set "selected", false
        perf.trigger "hide"

  reScaleHeight: =>
    console.log @collection
    @y_max = @collection.getMaxY @chartType
    @setYScale @y_max
    @scaleYAxis()
    for model in @collection.models
      model.trigger "set_line"

  reScaleWidth: =>
    @getElementWidth()
    @setXScale()

  scaleYAxis: =>
    yAxis = d3.svg.axis().scale(@yScale).ticks(4).orient("left")
    @yAxis.call(yAxis)

  moveCheckpoints: =>
    chartHeight = @getElementHeight() - @m[0] - @m[2]
    for label, i in @cp_labels
      x = @xScale @checkpoints[i].least_elapsed_time
      label["label"].transition().duration(1000)
        .attr("x", x)
        .attr("y", chartHeight)
      x = @xScale @checkpoints[i].least_elapsed_time
      label["divider"].transition().duration(1000)
        .attr("x1", x)
        .attr("x2", x)
        .attr("y2", chartHeight)

  remove: =>
    d3.select(".performances_graph").remove()
    # hide chart area and expand table
    # remove listeners

  createLines: =>
    @collection.each (model) =>
      line = new Results.Views.PerformanceLine
        model: model
        chart: @
      line.render()
