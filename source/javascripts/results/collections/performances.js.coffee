class Results.Collections.Performances extends Results.Collection
  model: Results.Models.Performance

  initialize: (collection, options) ->
    @instance = options.instance if options
    @colourScale = d3?.scale.category10()

  url: =>
    "/api/instances/#{@instance.get("id")}/performances"

  getMaxY: (property) =>
    values = @selected().map (x) -> x.getHighest(property)

    Math.max.apply Math, values

  selected: =>
    @where selected: true
