class FellRace.Collections.RacePublications extends FellRace.Collection
  model: FellRace.Models.RacePublication

  initialize: (models) ->
    super
    @on "add", (model, collection, options) =>
      @selectOne()
    @on "reset", (collection, options) =>
      @selectOne()

  deselectAll: =>
    _.each @where(selected: true), (race) =>
      race.trigger "deselect"

  selectOne: =>
    unless @findWhere(selected: true)
      @first()?.trigger "select"
