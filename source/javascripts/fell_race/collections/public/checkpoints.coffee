class FellRace.Collections.PublicCheckpoints extends FellRace.Collection
  model: FellRace.Models.PublicCheckpoint
  comparator: "pos"

  initialize: (models) ->
    super
    @sort()
    @on "add reset", =>
      @sort()

  add: (models, options) =>
    options ?= {}
    options['at'] = @length - 1
    super(models, options)
    @trigger('reset')

  names: =>
    names = []
    for cp in @models
      name = cp.get "name"
      times = cp.get "times"
      if times
        unless name == "Start"
          names.push name
    names
