class FellRace.Collections.Races extends FellRace.Collection
  model: FellRace.Models.Race

  url: =>
    "#{_fellrace.apiUrl()}/api/races"

  initialize: (models) ->
    super
    @on "add", (model, collection, options) =>
      if collection.first() is model
        model.trigger "select"

  deselectAll: =>
    _.each @where(selected: true), (race) =>
      race.trigger "deselect"
