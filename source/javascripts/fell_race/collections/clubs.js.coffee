class FellRace.Collections.Clubs extends Backbone.Collection
  model: FellRace.Models.Club
  url: "/api/clubs"

  findOrAdd: (opts) =>
    if model = @get(opts.id)
      return model
    else
      @add(opts)
      return @get(opts.id)
