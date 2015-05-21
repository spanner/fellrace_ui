class FellRace.Collections.Clubs extends Backbone.Collection
  model: FellRace.Models.Club
  url: ->
    "#{_fellrace.apiUrl()}/clubs"

  findOrAdd: (opts) =>
    if model = @get(opts.id)
      return model
    else
      @add(opts)
      return @get(opts.id)

  findOrAddBy: (opts) =>
    if model = @findWhere(opts)
      return model
    else
      @add(opts)
      return @findWhere(opts)

  ## Selection
  # The location of the highlight bar in the suggester interface is controlled by 
  # the assignment of a 'highlighted' property to one of the suggestions.
  #
  clearHighlight: () =>
    _.each @where(highlighted: true), (model) =>
      model.set "highlighted", false
    
  highlight: (index) =>
    @clearHighlight()
    @at(index)?.set "highlighted", true

  indexOfHighlight: () =>
    @indexOf @getHighlit()
    
  getHighlit: () =>
    @findWhere
      highlighted: true
