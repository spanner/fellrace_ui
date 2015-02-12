class FellRace.Collections.Races extends FellRace.Collection
  model: FellRace.Models.Race

  initialize: (models) ->
    super
    @on "add", (model, collection, options) =>
      if collection.first() is model
        model.trigger "select"

  deselectAll: =>
    _.each @where(selected: true), (race) =>
      race.trigger "deselect"
