class FellRace.Collections.Competitors extends Backbone.Collection
  model: FellRace.Models.Competitor

  findOrAdd: (opts) =>
    if model = @get(opts.id)
      return model
    else
      @add(opts)
      return @get(opts.id)
