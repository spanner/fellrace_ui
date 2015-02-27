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
