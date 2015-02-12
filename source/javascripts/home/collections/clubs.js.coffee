class Home.Collections.Clubs extends Backbone.Collection
  model: Home.Models.Club
  url: "/api/clubs"

  findOrAdd: (opts) =>
    if model = @get(opts.id)
      return model
    else
      @add(opts)
      return @get(opts.id)
