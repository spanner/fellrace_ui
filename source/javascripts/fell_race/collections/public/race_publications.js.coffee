class FellRace.Collections.RacePublications extends FellRace.Collection
  model: FellRace.Models.RacePublication

  url: =>
    "#{_fr.apiUrl()}/race_publications"

  deselectAll: =>
    _.each @where(selected: true), (race) =>
      race.trigger "deselect"

  add: (opts={}) =>
    if model = @findWhere(opts)
      model
    else
      super
