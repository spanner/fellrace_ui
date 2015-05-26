class FellRace.Collections.Categories extends Backbone.Collection
  model: FellRace.Models.Category

  url: ->
    "#{_fellrace.apiUrl()}/categories"

  findOrAddBy: (opts) =>
    if model = @findWhere(opts)
      return model
    else
      @add(opts)
      return @findWhere(opts)
